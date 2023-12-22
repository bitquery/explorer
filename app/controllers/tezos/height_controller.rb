class Tezos::HeightController < NetworkController
  layout 'tabs'
  before_action :query_date
  QUERY2 = <<-'GRAPHQL'
          query {
            tezos {
              blocks {
                maximum(of: height)
              }
            }
          }
  GRAPHQL
  def query_date
    # @block_date = Graphql::V1.query_with_retry(QUERY, variables: { height: @height.to_i,
    #                                                                network: @network[:network] }, context: { authorization: @streaming_access_token }).data.tezos.height[0].date.date
    @is_block_section = true
  # rescue
  #   @last_block_number = Graphql::V1.query_with_retry(QUERY2, variables: { network: @network[:network] }, context: { authorization: @streaming_access_token }).data.tezos.height[0].maximum
  #   redirect_to controller: :height, height: @last_block_number, action: params[:action]
  end
end