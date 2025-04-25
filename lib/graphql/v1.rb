require 'graphql/client'
require 'graphql/client/http'
require 'json'
require 'ostruct'
require 'net/http'
require 'uri'

module Graphql
  class V1
    ATTEMPTS = 2

    def self.query_with_retry(query, variables: {}, context: {})
      req = Thread.current[:current_request] rescue nil
      if req
        page_url = req.respond_to?(:original_url) ? req.original_url : req.url
        client_ip = req.remote_ip
        incoming_headers = req.headers.env
                              .select { |k,_| k.start_with?('HTTP_') }
                              .transform_keys { |k|
                                k.sub(/^HTTP_/, '')
                                 .split('_').map(&:capitalize).join('-')
                              }
        start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)
      end

      url = URI(BITQUERY_GRAPHQL)
      https = Net::HTTP.new(url.host, url.port)
      https.use_ssl = true if url.is_a?(URI::HTTPS)

      request = Net::HTTP::Post.new(url)
      request['Content-Type']  = 'application/json'
      request['X-API-KEY']     = ENV.fetch('EXPLORER_API_KEY', nil)
      request['Authorization'] = context[:authorization]


      body = { query: query, variables: variables }
      request.body = body.to_json
      attempt = 1

      BitqueryLogger.extra_context(
        query:     query,
        variables: variables,
        context:   context,
        attempt:   attempt
      )

      begin
        response = https.request(request)
      rescue Net::ReadTimeout => e
        if attempt < ATTEMPTS
          sleep 1
          attempt += 1
          retry
        else
          raise "All attempts failed: #{e.message}"
        end
      end

      elapsed_ms = if start_time
                     ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round(1)
                   end


      if req
        BitqueryLogger.info <<~LOG
          =======>v1========> GraphQL v1 call summary:
            • Page URL:      #{page_url}
            • Client IP:     #{client_ip}
            • Req-Headers:   #{incoming_headers.inspect}
            • Query (trunc): #{query.truncate(200)}
            • Resp code:     #{response.code}
            • Time (ms):     #{elapsed_ms}
        LOG
      end

      raw_body = response.body.to_s
      begin
        resp = JSON.parse(raw_body, object_class: OpenStruct)
      rescue JSON::ParserError => e
        empty_evm = OpenStruct.new(calls: [], token: [])
        return OpenStruct.new(data: OpenStruct.new(EVM: empty_evm), errors: [])
      end

      BitqueryLogger.extra_context(errors: resp.errors&.map(&:message))

      if resp.errors&.any? && resp.data.nil?
        raise 'GraphQL response errors, data is nil'
      elsif resp.errors&.any?
        raise 'GraphQL response errors'
      elsif resp.data.nil?
        raise 'GraphQL response data is nil'
      end

      resp
    end
  end
end
