require 'graphql/client'
require 'graphql/client/http'

module BitqueryGraphql
  HttpAdapter = GraphQL::Client::HTTP.new(BITQUERY_GRAPHQL)
  Schema = GraphQL::Client.load_schema(HttpAdapter)
  Client = GraphQL::Client.new(schema: Schema, execute: HttpAdapter)
end
