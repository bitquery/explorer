class Conflux::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
   query($network: ConfluxNetwork!, $address: String!) {
              conflux(network: $network) {
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
                  balance
                }
              }
            }
  GRAPHQL

  QUERY_CURRENCIES = Graphql::V1::Client.parse <<-'GRAPHQL'
   query($network: ConfluxNetwork!, $address: String!) {
              conflux(network: $network) {
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
                  balance
                }
    						transfers(receiver: {is: $address}, options: {desc: "count", limit: 100}){
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
    if @address.starts_with?('cfx:')
        result = Graphql::V1.instance.query_with_retry(query, variables: { network: @network[:network], address: @address }, context: {'Authorization': @streaming_access_token}).data.conflux
        @info = result.address.first
        @currencies = result.transfers.map(&:currency).sort_by { |c| c.address == '-' ? 0 : 1 }.uniq { |x| x.address } if result.try(:transfers)
    end
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency ? 'conflux/token' : 'conflux/smart_contract')
    end
  end

end
