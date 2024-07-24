module Stellar
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    QUERY = <<-GRAPHQL.freeze
    query ($network: StellarNetwork!, $address: String!) {
      stellar(network: $network) {
        outflow: transfers(
          options: {desc: "count", limit: 100}
          sender: {is: $address}
        ) {
          currency: currencyFrom {
            address
            symbol
            name
          }
          count
        }
        inflow: transfers(
          options: {desc: "count", limit: 100}
          receiver: {is: $address}
        ) {
          currency: currencyTo {
            address
            symbol
            name
          }
          count
        }
      }
    }
    GRAPHQL

    def money_flow; end

    private

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.stellar
      data_tables = result.outflow + result.inflow

      only_currencies = data_tables.map(&:currency)
      native_currency = only_currencies.select { |c| c.symbol == @network[:currency] }
      sorted_currencies = only_currencies.sort_by(&:symbol)

      all_currencies = (native_currency + sorted_currencies).uniq(&:name)

      @currencies = all_currencies
    end
  end
end
