module Eos
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    QUERY = <<~GRAPHQL.freeze
        query($address: String!){
        eos {
          address(address: {is: $address}) {
            address
            smartContract {
              contractType
              protocolType
            currency {
              symbol
              name
              tokenType
              decimals
            }
            }
      #{'      '}
          }
        }
      }
    GRAPHQL

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
          query ($address: String!) {
            eos {
              address(address: {is: $address}) {
                address
                smartContract {
                  contractType
                  protocolType
                  currency {
                    symbol
                    name
                    tokenType
                    decimals
                  }
                }
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
      result = Graphql::V1.query_with_retry(query, variables: { address: @address },
                                                   context: { authorization: @streaming_access_token }).data.eos
      @info = result.address.first
      return unless result.try(:transfers)

      @currencies = result.transfers.map(&:currency).sort_by do |c|
        c.address == 'eosio.token' ? 0 : 1
      end.uniq(&:address)
    end

    def redirect_by_type
      return unless (sc = @info.try(:smartContract))

      change_controller!(sc.currency ? 'eos/token' : 'eos/smart_contract')
    end
  end
end
