class Hedera::SitemapController < NetworkController
  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
      from: Date.today,
      # till: null,
      dateFormat: '%Y-%m-%d'
    }

    begin
      @response = BitqueryGraphql::Client.query(QUERY, variables: variables).data
    rescue Net::ReadTimeout => e
      Raven.capture_exception e
      sleep(1)
      retry
    end
  end
end
