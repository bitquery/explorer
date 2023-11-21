class Cardano::AddressController < NetworkController
  layout 'tabs'
  before_action :query_graphql

  QUERY = <<-'GRAPHQL'
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
    @info = Graphql::V1.query_with_retry(QUERY, variables: { network: @network[:network], address: @address }, context: { authorization: @streaming_access_token }).data.cardano.outputs.first.try(:output_address)
  end

end
