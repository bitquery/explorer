class Bitcoin::SitemapController < NetworkController

  QUERY = <<-'GRAPHQL'
           query ($network: BitcoinNetwork! $from: ISO8601DateTime){
              miners: bitcoin(network: $network ) {                  
                      outputs(options:{desc: "value", limit: 100 },
                      date: { since: $from }
                      txIndex: {is: 0}
                      outputDirection: {is: mining}
                      outputScriptType: {notIn: ["nulldata","nonstandard"]}
                    ) {
                      value
                      address: outputAddress{
                        address
                      }
                    }
              }
              receivers: bitcoin(network: $network ) {                  
                      outputs(options:{desc: "value", limit: 100 },
                      date: { since: $from }
                    ) {
                      value
                      address: outputAddress{
                        address
                      }
                    }
              }
              senders: bitcoin(network: $network ) {                  
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
    @response = Graphql::V1.query_with_retry(QUERY, variables: { from: Date.today - 14,
                                                                 network: @network[:network] }, context: { authorization: @streaming_access_token }).data
  end
end
