class Cardano::SitemapController < NetworkController

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($network: CardanoNetwork! $from: ISO8601DateTime){
              miners: cardano(network: $network ) { 
                  
                      outputs(options:{desc: "value", limit: 100 },
                      date: { since: $from }

                      txIndex: {is: 0}
                      outputDirection: {is: mining}
                      outputScriptType: {notIn: [nulldata,nonstandard]}

                    ) {

                      value
                      address: outputAddress{
                        address
                      }

                    }

              }

              receivers: cardano(network: $network ) { 
                  
                      outputs(options:{desc: "value", limit: 100 },
                      date: { since: $from }

                    ) {

                      value
                      address: outputAddress{
                        address
                      }

                    }

              }

              senders: cardano(network: $network ) { 
                  
                      inputs(options:{desc: "value", limit: 100 },
                      date: { since: $from }

                    ) {

                      value
                      address: inputAddress{
                        address
                      }

                    }

              }

           }
  GRAPHQL

  def index
    @response = BitqueryGraphql::Client.query(QUERY, variables: { from: Date.today - 14,
                                                                  network: @network[:network] }).data
  rescue Net::ReadTimeout => e
    Raven.capture_exception e
    sleep(1)
    retry
  end
end
