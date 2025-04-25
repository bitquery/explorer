require 'json'
require 'ostruct'
require 'net/http'
require 'uri'

module Graphql
  class V2
    ATTEMPTS = 1

    def self.query_with_retry(query, variables: {}, context: {}, use_eap: false)
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

      uri = use_eap ? BITQUERY_EAP_GRAPHQL : BITQUERY_STREAMING_GRAPHQL
      url = URI(uri)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Post.new(url)
      request['Content-Type']  = 'application/json'
      request['Authorization'] = context[:authorization]
      request['X-API-KEY']     = ENV.fetch('EXPLORER_API_KEY', nil)
      request.body             = { query: query, variables: variables }.to_json

      BitqueryLogger.extra_context(query: query, variables: variables, context: context, attempt: 1)

      begin
        response = http.request(request)
      rescue Net::ReadTimeout => e
        raise "All attempts failed: #{e.message}"
      end

      if start_time
        elapsed_ms = ((Process.clock_gettime(Process::CLOCK_MONOTONIC) - start_time) * 1000).round(1)
      end


      if req
        BitqueryLogger.info <<~LOG
          =======>v2========> GraphQL call summary:
            • Page URL:      #{page_url}
            • Client IP:     #{client_ip}
            • Req-Headers:   #{incoming_headers.inspect}
            • Query:         #{query.truncate(200)}
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
