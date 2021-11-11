class Tron::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            sender(sender: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }
                  
                            count
                  
                        }
                     
                   }

                  receivers: tron{
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            receiver(receiver: {not: "0x0000000000000000000000000000000000000000"}) {
                              address
                            }
                  
                            count
                  
                        }
                      
                  }

						      tokens: tron{
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            currency {
                              address
                              tokenId
                            }
                  
                            count
                  
                        }
                     
                   }

                  callers: tron{
                        smartContractCalls(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
  
                          ) {
                  
                    				txFrom {
                              address
                            }

                  
                            count
                  
                        }
                  }

                  contracts: tron{
                        smartContractCalls(options:{
                          desc: "count", 
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
    @response = BitqueryGraphql.instance.query_with_retry(QUERY, variables: { from: Date.today - 10 }).data
  end

end
