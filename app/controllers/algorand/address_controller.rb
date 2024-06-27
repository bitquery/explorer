module Algorand
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, only: %i[money_flow]

    before_action :set_address

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
    query ($address: String!){
      algorand{
        outbound: transfers(receiver: {is: $address}, options: {limit: 100}){
          currency{
            symbol
            tokenId
            name
          }
        }
        inbound: transfers(sender: {is: $address}, options: {limit: 100}){
          currency{
            symbol
            tokenId
            name
          }
        }
      }
    }
    GRAPHQL

    private

    def set_address
      @address = params[:address]
    end

    def query_graphql
      result = Graphql::V1.query_with_retry(QUERY_CURRENCIES, variables: { address: @address },
                                                              context: { authorization: @streaming_access_token }).data.algorand

      all_currencies = result.outbound + result.inbound
      @currencies = all_currencies.map(&:currency).sort_by { |c| c.tokenId == '' ? 0 : 1 }.uniq(&:tokenId)
    end
  end
end
