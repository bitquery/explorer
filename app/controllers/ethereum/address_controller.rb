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

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse  <<-'GRAPHQL'
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
    						transfers(receiver: {is: $address}, options: {desc: "count"}){
      							currency {
                      address
                      symbol
                      name
                    }
      							count
    						}
              }
            }
  GRAPHQL

  private

  def query_graphql
    @address = params[:address]
    query = action_name == 'graph' ? QUERY_CURRENCIES : QUERY
    result = @address.starts_with?('0x') &&
        BitqueryGraphql::Client.query(query, variables: {network: @network[:network], address: @address}).data.ethereum
    @info = result.address.first
    @currencies = result.transfers.map(&:currency).sort_by{|c| c.address=='-' ? 0 : 1 } if result.try(:transfers)
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency  ? 'ethereum/token' : 'ethereum/smart_contract')
    end
  end

end
