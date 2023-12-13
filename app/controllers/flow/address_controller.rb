module Flow
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    before_action :set_address
    before_action :breadcrumb

    QUERY = <<-'GRAPHQL'
      query ($network: FlowNetwork!, $address: String!) {
        flow(network: $network) {
          outflow: inputs(
            options: {desc: "count", limit: 100}
            address: {is: $address}
          ) {
            currency {
              address
              symbol
              name
            }
            count
          }
          inflow: outputs(
            options: {desc: "count", limit: 100}
            address: {is: $address}
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

    def set_address
      @address = params[:address]
    end

    def breadcrumb
      return if action_name == 'show'
    end

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY,
                                            variables: { network: @network[:network],
                                                         address: @address }, context: { authorization: @streaming_access_token }).data.flow
      all_currencies = result.outflow + result.inflow
      @currencies = all_currencies.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq { |x| x.address }
    end
  end
end
