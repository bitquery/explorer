module Ethereum
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    QUERY = <<-GRAPHQL.freeze
      query($network: EthereumNetwork!, $address: String!) {
        ethereum(network: $network) {
          address(address: {is: $address}){
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
        }
      }
    GRAPHQL

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
      query($network: EthereumNetwork!, $address: String!) {
        ethereum(network: $network) {
          address(address: {is: $address}){
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
          tin: transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}) {
            currency {
              address
              symbol
              name
            }
            count
          }
          tout: transfers(sender: {is: $address}, options: {desc: "count", limit: 100}) {
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
      return unless @address.starts_with?('0x')

      begin
        result = Graphql::V1.query_with_retry(query, variables: { network: @network[:network], address: @address },
                                                     context: { authorization: @streaming_access_token }).data.ethereum
        @info = result.address.first
        all_t = (result.try(:tin) || []) + (result.try(:tout) || [])
        @currencies = all_t.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq(&:address)
      rescue StandardError => e
        Rails.logger.error("GraphQL query error: #{e.message}")
        @info = nil
        @currencies = []
      end
    end

    def redirect_by_type
      return unless (sc = @info.try(:smartContract))

      change_controller!(sc.currency ? 'ethereum/token' : 'ethereum/smart_contract')
    end
  end
end
