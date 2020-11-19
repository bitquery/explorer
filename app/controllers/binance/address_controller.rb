class Binance::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse  <<-'GRAPHQL'
query (  $address: String!){
                        binance{
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
    if action_name == 'graph' || action_name == 'money_flow'
      result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: {address: @address}).data.binance
      @currencies = result.transfers.map(&:currency).sort_by{|c| c.token_id == 'BNB' ? 0 : 1 } if result.try(:transfers)
    end
  end
end
