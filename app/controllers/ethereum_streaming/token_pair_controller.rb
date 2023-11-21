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
    result = Graphql::V2.query_with_retry(QUERY, variables: {
      network: @network[:streaming], token1: @token1, token2: @token2 }, context: { authorization: @streaming_access_token }).data.evm.transfers

    @token1name = result.detect { |a| a.transfer.currency.smart_contract == @token1 }
    @token2name = result.detect { |a| a.transfer.currency.smart_contract == @token2 }

    @token1symbol = @token1name ? @token1name.transfer.currency.symbol : '-'
    @token2symbol = @token2name ? @token2name.transfer.currency.symbol : '-'

    @token1name = @token1name ? @token1name.transfer.currency.name : '-'
    @token2name = @token2name ? @token2name.transfer.currency.name : '-'
  end

end
