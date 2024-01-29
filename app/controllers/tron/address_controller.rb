class Tron::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY = <<-'GRAPHQL'
   query($address: String!) {
              tron{
                address(address: {is: $address}){
                  address 
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
                }
              }
            }
  GRAPHQL

  QUERY_CURRENCIES = <<-'GRAPHQL'
   query($address: String!) {
              tron{
                address(address: {is: $address}){
                  address 
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
    result = Graphql::V1.query_with_retry(query, variables: { address: @address }, context: { authorization: @streaming_access_token }).data.tron
    @info = result.address.first
    @currencies = result.transfers.map(&:currency).sort_by { |c| c.symbol == 'TRX' ? 0 : 1 }.uniq { |x| [x.address, x.token_id] } if result.try(:transfers)

  end

  def redirect_by_type
    if @info&.smartContract&.contractType
      if @info.smartContract.currency
        if @info.smartContract.currency.tokenType == 'TRC20'
          redirect_to controller: '/tron/trc20token', action: params[:action], address: @address and return
        end
      end
      redirect_to action: params[:action], controller: '/tron/smart_contract', address: @address and return
    end
  end
end
