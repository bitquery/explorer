module Elrond
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
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
        from: Time.zone.today
      }

      @response = Graphql::V1.query_with_retry(QUERY, variables:,
                                                      context: { authorization: @streaming_access_token }).data
    end
  end
end
