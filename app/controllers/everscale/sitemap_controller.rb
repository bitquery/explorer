module Everscale
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
      query ($network: EverscaleNetwork!, $from: ISO8601DateTime, $limit: Int!) {
        senders: everscale(network: $network) {
          transfers(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            sender {
              address
            }
            count
          }
        }
        receivers: everscale(network: $network) {
          transfers(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            receiver {
              address
            }
            count
          }
        }

        tokens: everscale(network: $network) {
          transfers(
            options: {desc: "count", asc: "currency.symbol", limit: $limit}
            date: {since: $from}
           ) {
            currency {
              symbol
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
