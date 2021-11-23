class Eos::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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

                  receivers: eos{
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

						      tokens: eos{
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

                  callers: eos{
                        smartContractCalls(options:{
                          desc: "count", 
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
    @response = BitqueryGraphql.instance.query_with_retry(QUERY, variables: { from: Date.today - 1 }).data
  end

end
