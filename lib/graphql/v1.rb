require 'graphql/client'
require 'graphql/client/http'
module Graphql
  class V1

    ATTEMPTS = 2

    def self.query_with_retry(query, variables: {}, context: {})
      url = URI(BITQUERY_GRAPHQL)

      https = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if uri.instance_of? URI::HTTPS

      request = Net::HTTP::Post.new(url)
      request['Content-Type'] = 'application/json'
      request['X-API-KEY'] = ENV['EXPLORER_API_KEY']
      request['Authorization'] = context[:authorization]

      body = {
        query: query,
        variables: variables
      }

      request.body = body.to_json
      attempt = 1

      ::BitqueryLogger.extra_context query: query,
                                     variables: variables,
                                     context: context,
                                     attempt: attempt

      begin
        response = https.request(request)
        resp = JSON.parse(response.read_body, object_class: OpenStruct)
        BitqueryLogger.extra_context errors: resp.errors&.map{|e| e.message}
      rescue Net::ReadTimeout => e
        if attempt >= ATTEMPTS
          raise 'All attempts failed'
        else
          sleep(1)
          attempt += 1
          retry
        end
      end

      if resp&.errors&.any? && resp&.data&.nil?
        raise 'GraphQL response errors, data is nil'
      elsif resp&.errors&.any?
        raise 'GraphQL response errors'
      elsif resp&.data&.nil?
        raise 'GraphQL response data is nil'
      end

      resp
    end

  end

end