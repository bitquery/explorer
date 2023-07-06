class EthereumStreaming::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair, :query_graphql

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
   query($network: EthereumNetwork!, $token1: String!,$token2: String!) {
              ethereum(network: $network) {
                address(address: {in: [$token1,$token2]}){
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


  def query_graphql

    result = BitqueryGraphql.instance.query_with_retry(QUERY, variables: {
              network: @network[:network], token1: @token1, token2: @token2 }).data.ethereum_streaming

    @token1name = result.address.detect{|a| a.address==@token1 }
    @token2name = result.address.detect{|a| a.address==@token2 }

    @token1symbol = @token1name ? @token1name.smart_contract.currency.symbol : '-'
    @token2symbol = @token2name ? @token2name.smart_contract.currency.symbol : '-'

    @token1name = @token1name ? @token1name.smart_contract.currency.name : '-'
    @token2name = @token2name ? @token2name.smart_contract.currency.name : '-'

  end

end
