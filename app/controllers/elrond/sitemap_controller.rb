module Elrond
  class SitemapController < NetworkController
    QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
      query ($network: ElrondNetwork!, $from: ISO8601DateTime, $limit: Int!) {
        senders: elrond(network: $network) {
          transfers(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            sender {
              address
            }
            count
          }
        }
        receiver: elrond(network: $network) {
          transfers(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            receiver {
              address
            }
            count
          }
        }
      }
    GRAPHQL

    def index
      variables = {
        limit: 100,
        network: @network[:network],
        from: Date.today
      }



       @response = Graphql::V1.instance.query_with_retry(QUERY, variables: variables, context: {'Authorization': @streaming_access_token}).data
    end
  end
end
