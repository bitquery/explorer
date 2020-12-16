class Algorand::AddressController  < NetworkController
  layout 'tabs'
  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse  <<-'GRAPHQL'
query (  $address: String!){
                        algorand{
                          transfers(receiver: {is: $address}){
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
  def query_graphql
    @address = params[:address]
    if action_name == 'money_flow'
      result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: {address: @address}).data.algorand
      @currencies = result.transfers.map(&:currency).sort_by{|c| c.token_id == '0' ? 0 : 1 }.uniq{|x| x.token_id } if result.try(:transfers)
    end
  end

end
