module Binance
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
                  query ($address: String!) {
                    binance {
                      transfers(receiver: {is: $address}, options: {limit: 100}) {
                        currency {
                          symbol
                          tokenId
                          name
                        }
                      }
                    }
                  }
    GRAPHQL

    private

    def query_graphql
      @address = params[:address]
      return unless action_name == 'money_flow'

      result = Graphql::V1.query_with_retry(QUERY_CURRENCIES, variables: { address: @address },
                                                              context: { authorization: @streaming_access_token }).data.binance
      return unless result.try(:transfers)

      @currencies = result.transfers.map(&:currency).sort_by do |c|
        c.token_id == 'BNB' ? 0 : 1
      end.uniq(&:token_id)
    end
  end
end
