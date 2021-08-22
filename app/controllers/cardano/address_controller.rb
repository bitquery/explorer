class Cardano::AddressController < NetworkController
  layout 'tabs'
  before_action :query_graphql

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
   query ($network: CardanoNetwork!,
          $address:String!){
            cardano(network: $network ){


              outputs(
                outputAddress: {is: $address}
              ){

                outputAddress {
                  annotation
                }


              }


            }
          }
  GRAPHQL


  def query_graphql
    @info = BitqueryGraphql::Client.query(QUERY, variables: {network: @network[:network], address: @address}).data.cardano.outputs.first.try(:output_address)
  rescue Net::ReadTimeout => e
    Raven.capture_exception e
    sleep(1)
    retry
  end
  end
