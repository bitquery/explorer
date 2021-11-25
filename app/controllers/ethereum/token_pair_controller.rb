class Ethereum::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
    						tin: transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}){
      							currency {
                      address
                      symbol
                      name
                    }
      							count
    						}
    						tout: transfers(sender: {is: $address}, options: {desc: "count", limit: 100}){
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
  def show
  end

  def trading_view
    @breadcrumbs << {name:'Trading view'}
  end

  def last_trades
    @breadcrumbs << {name: 'Last Trades'}
  end
  
  private
  
  def set_pair
    @token1 = params[:token1]
    @token2 = params[:token2]
  end
end
