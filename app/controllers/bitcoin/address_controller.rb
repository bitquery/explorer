class Bitcoin::AddressController < NetworkController
  layout 'tabs'
  before_action :query_graphql

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
   query ($network: BitcoinNetwork!,
          $address:String!){
            bitcoin(network: $network ){


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
    @info = BitqueryGraphql.instance.query_with_retry(QUERY, variables: {network: @network[:network], address: @address}).data&.bitcoin&.outputs&.first&.try(:output_address)
  end

end
