class Ethereum::SitemapController < NetworkController

  QUERY = <<-'GRAPHQL'
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
                  dex_protocols: ethereum(network: $network){
                        dexTrades(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {                 
                    				protocol
                            count                  
                        }
                  }
                  dex_exchanges: ethereum(network: $network){
                        dexTrades(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from } 
                          ) {               
                    				exchange{ fullName }
                            count                 
                        }
                  }
           }
  GRAPHQL

  def index
    @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Date.today - 10,
                                                                 network: @network[:network] }, context: { authorization: @streaming_access_token }).data
  end

end
