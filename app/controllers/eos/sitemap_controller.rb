module Eos
  class SitemapController < NetworkController
    QUERY = <<-GRAPHQL.freeze
           query ($from: ISO8601DateTime){
                    producers: eos{
                      blocks(options:{desc: "count", limit: 50},
                        date: {since: $from }
                        ) {
                          address: producer {
                            address
                          }
                          count
                      }
                    }
                   senders: eos{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {#{'               '}
                            sender(sender: {not: ""}) {
                              address
                            }#{'              '}
                            count#{'                '}
                        }#{'                    '}
                   }
                  receivers: eos{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {
                            receiver(receiver: {not: ""}) {
                              address
                            }
                            count
                        }
                  }
						      tokens: eos{
                        transfers(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {
                            currency {
                              address
                            }
                            count
                        }
                   }
                  callers: eos{
                        smartContractCalls(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {
                       caller: txFrom(txFrom: {not: ""}){
                          address
                        }
                            count
                        }
                  }
                  contracts: eos{
                        smartContractCalls(options:{
                          desc: "count",#{' '}
                          limit: 100},
                          date: {since: $from }
                          ) {
                    				smartContract {
                              address {
                                address
                              }
                            }
                            count
                        }
                  }
           }
    GRAPHQL

    def index
      @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Time.zone.today - 1 },
                                                      context: { authorization: @streaming_access_token }).data
    end
  end
end
