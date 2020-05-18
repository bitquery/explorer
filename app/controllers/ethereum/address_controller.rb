class Ethereum::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
   query($network: EthereumNetwork!, $address: String!) {
              ethereum(network: $network) {
                address(address: {is: $address}){
                  address 
                  annotation
                  
                  smartContract {
                    contractType
                    currency{
                      symbol
                      name
                      decimals
                      tokenType
                    }
                  }
                  balance
                }
              }
            }
  GRAPHQL

  private

  def query_graphql
    @address = params[:address]
    @info = @address.starts_with?('0x') &&
                BitqueryGraphql::Client.query(QUERY, variables: {network: @network[:network], address: @address}).data.ethereum.address.first
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency  ? 'ethereum/token' : 'ethereum/smart_contract')
    end
  end

end
