class Ethereum::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair, :query_graphql

  QUERY = <<-'GRAPHQL'
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
    if @streaming
      render '/ethereum/token_pair/trading_view'
    else
      render '/ethereum/token_pair/last_trades'
    end
  end

  def trading_view
    @breadcrumbs << { name: 'Trading view' }
  end

  def last_trades
    @breadcrumbs << { name: 'Last Trades' }
  end

  private

  def set_pair
    @token1 = params[:token1]
    @token2 = params[:token2]
  end

  def query_graphql
    response = ::Graphql::V1.query_with_retry(QUERY, variables: {
      network: @network[:network], token1: @token1, token2: @token2 }, context: { authorization: @streaming_access_token })

    if response.data.ethereum.address
      addresses = response.data.ethereum.address

      @token1entry = addresses.detect { |a| a.address==@token1 }
      @token2entry = addresses.detect { |a| a.address==@token2 }

      @token1symbol = @token1entry&.smartContract&.currency&.symbol || '-'
      @token2symbol = @token2entry&.smartContract&.currency&.symbol || '-'

      @token1name = @token1entry&.smartContract&.currency&.name || '-'
      @token2name = @token2entry&.smartContract&.currency&.name || '-'
    else
      # Handle the case where ethereum.address is nil or not present
      @token1symbol = @token2symbol = @token1name = @token2name = '-'
    end
  end



end
