module Ethereum
  class TokenPairController < NetworkController
    layout 'tabs'
    before_action :set_pair, :query_graphql

    QUERY = <<-GRAPHQL.freeze
    query ($network: evm_network, $token1: String!, $token2: String!) {
      EVM(dataset: combined, network: $network) {
        DEXTradeByTokens(
          where: { Trade: {Currency: {SmartContract: {is: $token1}}, Side: {Currency: {SmartContract: {is: $token2}}}}}
          limit: {count: 1}
        ) {
          Trade {
            Currency {
              SmartContract
              Symbol
              Name
            }
            Side {
              Currency {
                Symbol
                SmartContract
                Name
              }
            }
          }
        }
      }
    }
    GRAPHQL

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
        network: @network[:streaming], token1: @token1, token2: @token2
      }, context: { authorization: @streaming_access_token }).data.EVM

      trade = response.DEXTradeByTokens.first&.Trade
      @token1entry = trade&.Currency
      @token2entry = trade&.Side&.Currency

      @token1symbol = @token1entry&.Symbol || '-'
      @token2symbol = @token2entry&.Symbol || '-'

      @token1name = @token1entry&.Name || '-'
      @token2name = @token2entry&.Name || '-'
    end
  end
end
