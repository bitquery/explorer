module Stellar
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($network: StellarNetwork! $from: ISO8601DateTime){
                   senders: stellar(network: $network){
                        transfers(
                          sender: {not: ""},
                          options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                 '}
                            sender {
                              address
                            }#{'                  '}
                            count#{'                 '}
                        }#{'                     '}
                   }
                  receivers: stellar(network: $network){
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
