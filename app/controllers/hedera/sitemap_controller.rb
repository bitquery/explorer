module Hedera
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
    query ($network: HederaNetwork!, $limit: Int!, $offset: Int!, $from: ISO8601DateTime, $till: ISO8601DateTime) {
      topics: hedera(network: $network) {
        messages(
          options: {desc: "count", limit: $limit, offset: $offset}
          date: {since: $from, till: $till}
        ) {
          account: entity(entityType: {is: topic}) {
            id
          }
          count
        }
      }
    }
    GRAPHQL

    def index
      variables = {
        limit: 100,
        offset: 0,
        network: @network[:network],
        from: Time.zone.today,
        # till: null,
        dateFormat: '%Y-%m-%d'
      }

      @response = Graphql::V1.query_with_retry(QUERY, variables:,
                                                      context: { authorization: @streaming_access_token }).data
    end
  end
end
