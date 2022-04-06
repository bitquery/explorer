module Flow
  class SitemapController < NetworkController
    QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
      query ($network: FlowNetwork!, $from: ISO8601DateTime, $limit: Int!) {
        proposers: flow(network: $network) {
          transactions(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            proposer {
              address
            }
            count
          }
        }

        senders: flow(network: $network) {
          inputs(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            address {
              address
            }
            count
          }
        }

        receivers: flow(network: $network) {
          outputs(options: {desc: "count", limit: $limit}, date: {since: $from}) {
            address {
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

       @response = BitqueryGraphql.instance.query_with_retry(QUERY, variables: variables).data
    end
  end
end
