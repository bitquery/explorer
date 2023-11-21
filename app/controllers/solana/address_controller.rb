module Solana
  class AddressController < NetworkController
    layout 'tabs'

    before_action :set_address

    before_action :query_graphql, only: %i[money_flow]

    MONEY_FLOW_QUERY = <<-'GRAPHQL'
      query ($network: SolanaNetwork!, $address: String!) {
        solana(network: $network) {
          outflow: transfers(
            options: {desc: "count", limit: 100}
            senderAddress: {is: $address}
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
            receiverAddress: {is: $address}
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

    private

    def set_address
      @address = params[:address]
    end

    def breadcrumb
      return if action_name == 'show'
    end

    def query_graphql
      result = Graphql::V1.query_with_retry(MONEY_FLOW_QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.solana

      all_results = (result.outflow || []) + (result.inflow || [])
      @currencies = all_results.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq(&:address)
    end
  end
end
