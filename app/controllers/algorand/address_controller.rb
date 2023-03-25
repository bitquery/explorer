class Algorand::AddressController < NetworkController
  layout 'tabs'

  before_action :query_graphql, only: %i[money_flow]

  before_action :set_address

  QUERY_CURRENCIES = BitqueryGraphql::Client.parse <<-'GRAPHQL'
    query ($address: String!){
      algorand{
        outbound: transfers(receiver: {is: $address}, options: {limit: 100}){
          currency{
            symbol
            tokenId
            name
          }
        }

        inbound: transfers(sender: {is: $address}, options: {limit: 100}){
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

  def set_address
    @address = params[:address]
  end

  def query_graphql
    result = BitqueryGraphql.instance.query_with_retry(QUERY_CURRENCIES, variables: { address: @address }).data.algorand

    all_currencies = result.outbound + result.inbound
    @currencies = all_currencies.map(&:currency).sort_by { |c| c.token_id == '' ? 0 : 1 }.uniq(&:token_id)
  end
end
