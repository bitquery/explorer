require "graphql/client"
require "graphql/client/http"

module BitqueryGraphql

    HttpAdapter = GraphQL::Client::HTTP.new(BITQUERY_GRAPHQL) do
      def headers(context)
        # set http headers
        { "X-API-KEY": ENV['EXPLORER_API_KEY'].to_s }
      end
    end
    Schema = GraphQL::Client.load_schema(HttpAdapter)
    Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)

end
