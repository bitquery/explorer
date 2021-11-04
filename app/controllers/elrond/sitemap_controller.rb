module Elrond
  class SitemapController < NetworkController
    QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
        calls: elrond(network: $network) {
          calls(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            smartContractAddress{
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

      begin
        @response = BitqueryGraphql::Client.query(QUERY, variables: variables).data
      rescue Net::ReadTimeout => e
        Raven.capture_exception e
        sleep(1)
        retry
      end
    end
  end
end
