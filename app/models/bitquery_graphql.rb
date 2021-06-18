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

end
