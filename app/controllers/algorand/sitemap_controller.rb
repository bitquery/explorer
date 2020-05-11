class Algorand::SitemapController < NetworkController

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
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
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            sender(sender: {not: ""}) {
                              address
                            }
                  
                            count
                  
                        }
                     
                   }

                  receivers: algorand(network: $network){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            receiver(receiver: {not: ""}) {
                              address
                            }
                  
                            count
                  
                        }
                      
                  }

						      tokens: algorand(network: $network){
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            currency {
                              tokenId
                            }
                  
                            count
                  
                        }
                     
                   }

                  contracts: algorand(network: $network){
                        smartContractCalls(options:{
                          desc: "count", 
                          limit: 100}
  
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
    @response = BitqueryGraphql::Client.query(QUERY, variables: {from: Date.today-60,
                                                                 network: @network[:network]}).data
  end

end
