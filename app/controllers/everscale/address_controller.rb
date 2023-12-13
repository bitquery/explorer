module Everscale
  class AddressController < NetworkController
    layout 'tabs'

    before_action :set_address_hash
    before_action :breadcrumb
    before_action :query_graphql, only: %i[money_flow]

    QUERY = <<-'GRAPHQL'
      query ($network: EverscaleNetwork!, $address: String!) {
        everscale(network: $network) {
          outflow: transfers(
            options: {desc: "count", limit: 100}
            transferSender: {is: $address}
          ) {
            currency {
              address
              symbol
              name
            }
            count
          }
          inflow: transfers(
            options: {desc: "count", limit: 100}
            transferReceiver: {is: $address}
          ) {
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

    def show; end

    private

    def set_address_hash
      @address = params[:address]
    end

    def breadcrumb
      return if action_name != 'show'
    end

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.everscale
      all_currencies = result.outflow + result.inflow
      @currencies = all_currencies.map(&:currency).sort_by { |c| c.symbol == @network[:currency] ? 0 : 1 }.uniq { |x| [x.name, x.symbol] }
    end
  end
end
