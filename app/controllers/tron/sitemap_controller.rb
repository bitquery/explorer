module Tron
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($from: ISO8601DateTime){
                    #miners: tron{
                    #  blocks(options:{desc: "count", limit: 50},
                    #    date: {since: $from }
                    #    ) {
                    #
                    #      address: miner {
                    #        address
                    #      }
                    #
                    #      count
                    #
                    #  }
                    #}
                   senders: tron{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                  '}
                            sender(sender: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }#{'                 '}
                            count#{'                  '}
                        }#{'                    '}
                   }
                  receivers: tron{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                '}
                            receiver(receiver: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }#{'               '}
                            count#{'                  '}
                        }#{'                      '}
                  }
						      tokens: tron{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                  '}
                            currency {
                              address
                              tokenId
                            }#{'                 '}
                            count#{'                 '}
                        }#{'                    '}
                   }
                  callers: tron{
                        smartContractCalls(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }#{'  '}
                          ) {#{'                 '}
                    				txFrom {
                              address
                            }#{'                  '}
                            count#{'                 '}
                        }
                  }
                  contracts: tron{
                        smartContractCalls(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }#{' '}
                          ) {#{'                 '}
                    				smartContract {
                              address {
                                address
                              }
                            }#{'                 '}
                            count#{'                  '}
                        }
                  }
                  dex_protocols: tron {
                        dexTrades(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }#{' '}
                          ) {#{'                 '}
                    				protocol
                            count#{'                 '}
                        }
                  }
                  dex_exchanges: tron {
                        dexTrades(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'                '}
                    				exchange{ fullName }
                            count#{'                 '}
                        }
                  }
           }
    GRAPHQL

    def index
      @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Time.zone.today - 10 },
                                                      context: { authorization: @streaming_access_token }).data
    end
  end
end
