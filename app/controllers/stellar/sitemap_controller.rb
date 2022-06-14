class Stellar::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($network: StellarNetwork! $from: ISO8601DateTime){

                   senders: stellar(network: $network){
                        transfers(
                          sender: {not: ""},
                          options:{
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

                  receivers: stellar(network: $network){
                        transfers(
                          receiver: {not: ""},
                          options:{
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


           }
  GRAPHQL

  def index
    @response = BitqueryGraphql.instance.query_with_retry(QUERY, variables: { from: Date.today - 10,
                                                                              network: @network[:network]  }).data
  end

end
