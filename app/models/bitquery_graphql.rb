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
    begin
      client.query definition, variables: variables, context: context
    rescue Net::ReadTimeout => e
      if attempt>=ATTEMPTS
        raise
      else
        sleep(1)
        attempt += 1
        retry
      end
    end


  end

end
