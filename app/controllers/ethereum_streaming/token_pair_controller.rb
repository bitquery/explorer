class EthereumStreaming::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair, :query_graphql

  QUERY = <<-'GRAPHQL'
    query ($network: evm_network, $token1: String!, $token2: String!) {
      EVM(dataset: archive, network: $network) {
        Transfers(
          where: {Transfer: {Currency: {SmartContract: {in: [$token1, $token2]}}}}
          limitBy: {count: 1 by: Transfer_Currency_SmartContract}
        ) {
          Transfer {
            Currency {
              SmartContract
              Symbol
              Name
              Decimals
              ProtocolName
            }
          }
        }
      }
    }
  GRAPHQL

  def show
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
    response = ::Graphql::V2.query_with_retry(QUERY, variables: {
      network: @network[:network], token1: @token1, token2: @token2 }, context: { authorization: @streaming_access_token }).data.EVM.Transfers

      @token1entry = response.detect {|a| a.Transfer.Currency.SmartContract==@token1}
      @token2entry = response.detect {|a| a.Transfer.Currency.SmartContract==@token2}

      @token1symbol =@token1entry.Transfer.Currency.Symbol || '-'
      @token2symbol =@token2entry.Transfer.Currency.Symbol || '-'

      @token1name = @token1entry.Transfer.Currency.Name || '-'
      @token2name = @token2entry.Transfer.Currency.Name || '-'

  end
end
