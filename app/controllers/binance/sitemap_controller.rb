class Binance::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
    @response = BitqueryGraphql::Client.query(QUERY, variables: { from: Date.today - 30 }).data
  rescue Net::ReadTimeout => e
    Raven.capture_exception e
    sleep(1)
    retry
  end

end
