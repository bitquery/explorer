module Conflux
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    QUERY = <<-GRAPHQL.freeze
   query($network: ConfluxNetwork!, $address: String!) {
              conflux(network: $network) {
                address(address: {is: $address}){
                  address#{' '}
                  annotation
                  smartContract {
                    contractType
                    currency{
                      symbol
                      name
                      decimals
                      tokenType
                    }
                  }
                  balance
                }
              }
            }
    GRAPHQL

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
                query ($network: ConfluxNetwork!, $address: String!) {
                  conflux(network: $network) {
                    address(address: {is: $address}) {
                      address
                      annotation
                      smartContract {
                        contractType
                        currency {
                          symbol
                          name
                          decimals
                          tokenType
                        }
                      }
                      balance
                    }
                    transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}) {
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

    def query_graphql
      @address = params[:address]
      query = action_name == 'money_flow' ? QUERY_CURRENCIES : QUERY
      return unless @address.starts_with?('cfx:')

      result = Graphql::V1.query_with_retry(query, variables: { network: @network[:network], address: @address },
                                                   context: { authorization: @streaming_access_token }).data.conflux
      @info = result.address.first
      return unless result.try(:transfers)

      @currencies = result.transfers.map(&:currency).sort_by do |c|
        c.address == '-' ? 0 : 1
      end.uniq(&:address)
    end

    def redirect_by_type
      return unless (sc = @info.try(:smartContract))

      change_controller!(sc.currency ? 'conflux/token' : 'conflux/smart_contract')
    end
  end
end
