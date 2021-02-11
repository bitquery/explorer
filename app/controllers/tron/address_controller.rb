class Tron::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
    						transfers(receiver: {is: $address}, options: {desc: "count"}){
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
    result = BitqueryGraphql::Client.query(query, variables: { address: @address }).data.tron
    @info = result.address.first
    if result.try(:transfers)
      @currencies = result.transfers.map(&:currency).sort_by do |c|
                      c.symbol == 'TRX' ? 0 : 1
                    end.uniq { |x| [x.address, x.token_id] }
    end
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller!(sc.currency ? 'tron/trc20token' : 'tron/smart_contract')
    end
  end
end
