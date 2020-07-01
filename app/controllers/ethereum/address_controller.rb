class Ethereum::AddressController < NetworkController
  layout 'tabs'

  before_action :query, :query_currencies, :query_graphql, :redirect_by_type

  def query
    q = BitqueryGraphql::Client.parse  <<-"GRAPHQL"
   query($network: #{@network[:network_type] || 'EthereumNetwork!'}, $address: String!) {
              #{@network[:protocol] || 'ethereum'}(network: $network) {
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
    Kernel.const_set('QUERY', q)
  end

  def query_currencies
    q = BitqueryGraphql::Client.parse  <<-"GRAPHQL"
   query($network: #{@network[:network_type] || 'EthereumNetwork!'}, $address: String!) {
              #{@network[:protocol] || 'ethereum'}(network: $network) {
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
    Kernel.const_set('QUERY_CURRENCIES', q)
  end


  private

  def query_graphql
    @address = params[:address]
    query = action_name == 'graph' ? QUERY_CURRENCIES : QUERY
    if @address.starts_with?('0x')
      result = BitqueryGraphql::Client.query(query, variables: {network: @network[:network], address: @address}).data.try(@network[:protocol] || 'ethereum')
      @info = result.address.first
      @currencies = result.transfers.map(&:currency).sort_by{|c| c.address=='-' ? 0 : 1 } if result.try(:transfers)
    end
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency  ? 'ethereum/token' : 'ethereum/smart_contract')
    end
  end

end
