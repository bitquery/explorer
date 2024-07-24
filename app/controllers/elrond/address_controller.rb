module Elrond
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    before_action :set_address
    before_action :breadcrumb

    QUERY = <<-GRAPHQL.freeze
      query ($network: ElrondNetwork!, $address: String!) {
        elrond(network: $network) {
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
    def money_flow; end

    private

    def set_address
      @address = params[:address]
    end

    def breadcrumb
      nil if action_name == 'show'
    end

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.elrond
      all_currencies = result.outflow + result.inflow
      @currencies = all_currencies.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq(&:address)
    end
  end
end
