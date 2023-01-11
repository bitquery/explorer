class Stellar::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, only: %i[money_flow]

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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

  private

  def query_graphql
    result = BitqueryGraphql.instance.query_with_retry(QUERY,
                                           variables: { network: @network[:network],
                                                        address: @address }).data.stellar
    all_currencies = result.outflow + result.inflow
    only_currencies = all_currencies.map(&:currency).uniq(&:name)

    native_currency = only_currencies.select { |c| c.symbol == @network[:currency] }
    sorted_currencies = only_currencies.sort_by(&:symbol)

    @currencies = native_currency + sorted_currencies
  end
end
