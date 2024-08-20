module Binance
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($from: ISO8601DateTime) {
            senders: binance {
              transfers(options: {desc: "count", limit: 100}, date: {since: $from}) {
                sender {
                  address
                }
                count
              }
            }
            receivers: binance {
              transfers(options: {desc: "count", limit: 100}, date: {since: $from}) {
                receiver {
                  address
                }
                count
              }
            }
            tokens: binance {
              transfers(options: {desc: "count", limit: 100}, date: {since: $from}) {
                currency {
                  tokenId
                }
                count
              }
            }
          }
    GRAPHQL

    def index
      @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Time.zone.today - 30 },
                                                      context: { authorization: @streaming_access_token }).data
    end
  end
end
