require "graphql/client"
require "graphql/client/http"

class BitqueryGraphql

  include Singleton

  attr_reader :client

  def initialize

    http_adapter = GraphQL::Client::HTTP.new(BITQUERY_GRAPHQL) do
      def headers(context)
        # set http headers
        { "X-API-KEY": ENV['EXPLORER_API_KEY'].to_s }
      end
    end
    schema = GraphQL::Client.load_schema(http_adapter)
    @client = GraphQL::Client.new(schema: schema, execute: http_adapter)

  end

  Client = BitqueryGraphql.instance.client

  ATTEMPTS = 2

  def query_with_retry(definition, variables: {}, context: {})
    attempt = 1

    ::BitqueryLogger.extra_context query: definition.source_document.to_query_string,
                                   variables: variables,
                                   context: context,
                                   attempt: attempt

    begin
      resp = client.query definition, variables: variables, context: context
      BitqueryLogger.extra_context errors: resp.errors.presence
    rescue Net::ReadTimeout => e
      if attempt >= ATTEMPTS
        raise "All attempts failed"
      else
        sleep(1)
        attempt += 1
        retry
      end
    end

    if resp.errors.any? && resp.data.nil?
      raise 'GraphQL response errors, data is nil'
    elsif resp.errors.any?
      raise 'GraphQL response errors'
    elsif resp.data.nil?
      raise 'GraphQL response data is nil'
    end

    resp
  end

end
