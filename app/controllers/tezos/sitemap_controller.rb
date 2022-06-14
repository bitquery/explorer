class Tezos::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($network: TezosNetwork! $from: ISO8601DateTime){

                   bakers: tezos(network: $network){
                      blocks(options:{desc: "count", limit: 50},
                        date: {since: $from }
                        ) {

                          address: baker {
                            address
                          }

                          count

                      }
                    }


                   senders: tezos(network: $network){
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

                  receivers: tezos(network: $network){
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
