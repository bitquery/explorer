module Algorand
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($network: AlgorandNetwork! $from: ISO8601DateTime){
                    proposers: algorand(network: $network){
                      blocks(options:{desc: "count", limit: 50},
                        date: {since: $from }
                        ) {
                          address: proposer {
                            address
                          }
                          count
                      }
                    }
                   senders: algorand(network: $network){
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          )#{'                 '}
                            sender(sender: {not: ""}) {
                              address
                            }#{'                  '}
                            count#{'                 '}
                        }#{'                    '}
                   }
                  receivers: algorand(network: $network){
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                '}
                            receiver(receiver: {not: ""}) {
                              address
                            }#{'                 '}
                            count#{'                  '}
                        }#{'                      '}
                  }
						      tokens: algorand(network: $network){
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                 '}
                            currency {
                              tokenId
                            }#{'                  '}
                            count
                        }#{'                   '}
                   }
                  contracts: algorand(network: $network){
                        smartContractCalls(options:{
                          desc: "count",#{' '}
                          limit: 100}#{' '}
                          ) {#{'                  '}
                    				smartContract {
                              address {
                                address
                              }
                            }#{'                 '}
                            count#{'                 '}
                        }
                  }
           }
    GRAPHQL

    def index
      @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Time.zone.today - 60,
                                                                   network: @network[:network] }, context: { authorization: @streaming_access_token }).data
    end
  end
end
