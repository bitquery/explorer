class Binance::SitemapController < NetworkController

  QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
           query ($from: ISO8601DateTime){

                   senders: binance {
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            sender {
                              address
                            }
                  
                            count
                  
                        }
                     
                   }

                   receivers: binance {
                        transfers(options:{
                          desc: "count", 
                          limit: 100},
                          date: {since: $from }
                          ) {
                  
                            receiver {
                              address
                            }
                  
                            count
                  
                        }
                     
                   }

                   tokens: binance {
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

           }
  GRAPHQL

  def index
    @response = Graphql::V1.instance.query_with_retry(QUERY, variables: { from: Date.today - 30 }, context: {'Authorization': @streaming_access_token}).data
  end

end
