class Binance::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<~'GRAPHQL'
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
    if action_name == 'money_flow'
      result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: { address: @address }).data.binance
      if result.try(:transfers)
        @currencies = result.transfers.map(&:currency).sort_by do |c|
                        c.token_id == 'BNB' ? 0 : 1
                      end.uniq { |x| x.token_id }
      end
    end
  end
end
