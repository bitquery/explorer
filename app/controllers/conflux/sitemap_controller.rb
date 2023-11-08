class Conflux::SitemapController < NetworkController

  QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
           query ($network: ConfluxNetwork! $from: ISO8601DateTime){


                    miners: conflux(network: $network){
                      blocks(options:{desc: "count", limit: 50},
                        date: {since: $from }
                        ) {

                          address: miner {
                            address
                          }

                          count

                      }
                    }

                   senders: conflux(network: $network){
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

                  receivers: conflux(network: $network){
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

						      tokens: conflux(network: $network){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {                  
                            currency {
                              address
                            }                  
                            count                 
                        }                     
                   }

                  callers: conflux(network: $network){
                        smartContractCalls(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
  
                          ) {
                  
                    				caller {
                              address
                            }

                  
                            count
                  
                        }
                  }

                  contracts: conflux(network: $network){
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
    @response = Graphql::V1.instance.query_with_retry(QUERY, variables: { from: Date.today - 10,
                                                                  network: @network[:network] }, context: {'Authorization': @streaming_access_token}).data
  end

end
