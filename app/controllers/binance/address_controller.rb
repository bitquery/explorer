class Binance::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<-'GRAPHQL'
query (  $address: String!){
                        binance{
                          transfers(receiver: {is: $address}, options: {limit: 100}){
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
      begin
        result = BitqueryGraphql::Client.query(QUERY_CURRENCIES, variables: { address: @address }).data.binance
        @currencies = result.transfers.map(&:currency).sort_by { |c| c.token_id == 'BNB' ? 0 : 1 }.uniq { |x| x.token_id } if result.try(:transfers)
      rescue Net::ReadTimeout => e
        Raven.capture_exception e
        sleep(1)
        retry
      end
    end
  end
end
