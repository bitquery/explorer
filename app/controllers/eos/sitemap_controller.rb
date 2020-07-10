class Eos::SitemapController < NetworkController

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
           query ($network: EthereumNetwork! $from: ISO8601DateTime){


                    miners: ethereum(network: $network){
                      blocks(options:{desc: "count", limit: 50},
                        date: {since: $from }
                        ) {

                          address: miner {
                            address
                          }

                          count

                      }
                    }

                   senders: ethereum(network: $network){
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

                  receivers: ethereum(network: $network){
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

						      tokens: ethereum(network: $network){
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

                  callers: ethereum(network: $network){
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

                  contracts: ethereum(network: $network){
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
    @response = BitqueryGraphql::Client.query(QUERY, variables: {from: Date.today-10,
                                                                 network: @network[:network]}).data


  end

end
