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

      query  = action_name == 'money_flow' ? QUERY_CURRENCIES : QUERY
      result = safe_fetch_tron(query)
      return if result.nil?

      @info = result.address&.first
      return unless result.try(:transfers)

      @currencies = result.transfers.map(&:currency).sort_by do |c|
                      c.symbol == 'TRX' ? 0 : 1
                    end.uniq { |x| [x.address, x.token_id] }
    end

    # Returns nil when the lookup fails, so the page renders without address
    # detail instead of returning 5xx. Sustained 5xx on entity pages is read by
    # search engines as a signal to drop the URL from the index.
    def safe_fetch_tron(query)
      Graphql::V1
        .query_with_retry(
          query,
          variables: { address: @address },
          context:   { authorization: @streaming_access_token }
        )
        .data&.tron
    rescue StandardError => e
      BitqueryLogger.error("[Tron::AddressController] GraphQL fetch error: #{e.class}: #{e.message}")
      nil
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
