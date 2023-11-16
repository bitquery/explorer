class Algorand::TokenController < ::NetworkController
  layout 'tabs'

  before_action :query_graphql

  QUERY = <<-'GRAPHQL'
   query($network: AlgorandNetwork!, $id: Int!) {
              algorand(network: $network ) {
                transactions(txCurrency:{is: $id}) {
                  currency {
                    name
                    symbol
                  }
                }
              }
            }
  GRAPHQL

  private

  def query_graphql
    if (@native_token = (@id == @network[:currency]))
      @id = 0
    else
      @id = @id.to_i
      @token_info = Graphql::V1.query_with_retry(QUERY, variables: { network: @network[:network], id: @id }, context: { authorization: @streaming_access_token }).data.algorand.transactions.first.currency
    end
  end

end
