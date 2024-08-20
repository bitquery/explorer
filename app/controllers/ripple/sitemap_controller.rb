module Ripple
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($network: RippleNetwork! $from: ISO8601DateTime){
                   senders: ripple(network: $network){
                        transfers(
                          sender: {not: ""},
                          options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                 '}
                            sender {
                              address
                            }#{'                 '}
                            count#{'              '}
                        }#{'     '}
                   }
                  receivers: ripple(network: $network){
                        transfers(
                          receiver: {not: ""},
                          options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {
                            receiver {
                              address
                            }
                            count
                        }
                  }
           }
    GRAPHQL

    def index
      @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Time.zone.today - 10,
                                                                   network: @network[:network] }, context: { authorization: @streaming_access_token }).data
    end
  end
end
