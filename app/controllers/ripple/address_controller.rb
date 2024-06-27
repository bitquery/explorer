module Ripple
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    QUERY = <<-GRAPHQL.freeze
    query ($network: RippleNetwork!, $address: String!) {
      ripple(network: $network) {
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

    private

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.ripple
      data_tables = result.outflow + result.inflow

      only_currencies = data_tables.map(&:currency)
      native_currency = only_currencies.select { |c| c.symbol == @network[:currency] }
      sorted_currencies = only_currencies.sort_by(&:symbol)

      all_currencies = (native_currency + sorted_currencies).uniq(&:symbol)

      @currencies = all_currencies
    end
  end
end
