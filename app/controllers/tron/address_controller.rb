module Tron
  class AddressController < NetworkController
    layout 'tabs'

    before_action :query_graphql, :redirect_by_type

    QUERY = <<-GRAPHQL.freeze
   query($address: String!) {
              tron{
                address(address: {is: $address}){
                  address#{' '}
                  annotation
   #{'               '}
                  smartContract {
                    contractType
                    currency{
                      symbol
                      name
                      decimals
                      tokenType
                    }
                  }
                }
              }
            }
    GRAPHQL

    QUERY_CURRENCIES = <<-GRAPHQL.freeze
   query($address: String!) {
              tron{
                address(address: {is: $address}){
                  address#{' '}
                  annotation
   #{'               '}
                  smartContract {
                    contractType
                    currency{
                      symbol
                      name
                      decimals
                      tokenType
                    }
                  }
                }
    						transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}){
      							currency {
                      address
                      symbol
                      tokenType
                      tokenId
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
                                                   context: { authorization: @streaming_access_token }).data.tron
      @info = result.address.first
      return unless result.try(:transfers)

      @currencies = result.transfers.map(&:currency).sort_by do |c|
                      c.symbol == 'TRX' ? 0 : 1
                    end.uniq { |x| [x.address, x.token_id] }
    end

    def redirect_by_type
      return unless @info&.smartContract&.contractType

      if @info.smartContract.currency && (@info.smartContract.currency.tokenType == 'TRC20')
        redirect_to controller: '/tron/trc20token', action: params[:action], address: @address and return
      end

      redirect_to action: params[:action], controller: '/tron/smart_contract', address: @address and return
    end
  end
end
