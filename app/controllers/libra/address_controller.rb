class Libra::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, :redirect_by_type

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse  <<-'GRAPHQL'
   query($address: String!) {
              libra{
    						transfers(receiver: {is: $address}, options: {desc: "count"}){
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
    if action_name == 'graph'
        result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: {network: @network[:network], address: @address}).data.libra
        @currencies = result.transfers.map(&:currency).sort_by{|c| c.address=='-' ? 0 : 1 } if result.try(:transfers)
    end
  end

  def redirect_by_type
    if sc = @info.try(:smart_contract)
      change_controller! (sc.currency  ? 'libra/token' : 'libra/smart_contract')
    end
  end

end
