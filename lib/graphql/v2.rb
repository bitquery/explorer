require 'json'
require 'ostruct'
require 'net/http'
require 'uri'

module Graphql
  class V2
    ATTEMPTS = 1

    def self.query_with_retry(query, variables: {}, context: {}, use_eap: false)

      uri = use_eap ? BITQUERY_EAP_GRAPHQL : BITQUERY_STREAMING_GRAPHQL
      url = URI(uri)

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = (url.scheme == 'https')

      request = Net::HTTP::Post.new(url)
      request['Content-Type']  = 'application/json'
      request['Authorization'] = context[:authorization]
      request['X-API-KEY']     = ENV.fetch('EXPLORER_API_KEY', nil)
      request.body = { query: query, variables: variables }.to_json
      BitqueryLogger.info  "========v2======== Request headers: #{request.to_hash.inspect}"

      attempt = 1
      BitqueryLogger.extra_context(query: query, variables: variables, context: context, attempt: attempt)

      begin
        response = http.request(request)
      rescue Net::ReadTimeout => e
        if attempt < ATTEMPTS
          attempt += 1
          sleep 1
          retry
        else
          raise "All attempts failed: #{e.message}"
        end
      end

      BitqueryLogger.info  "========v2======== HTTP status: #{response.code} #{response.message}"
      BitqueryLogger.info  "========v2======== Response headers: #{response.to_hash.inspect}"

      raw_body = response.body.to_s

      begin
        resp = JSON.parse(raw_body, object_class: OpenStruct)
      rescue JSON::ParserError => e
        BitqueryLogger.error "========v2======== JSON::ParserError: #{e.message}, body=#{raw_body.inspect}"
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
