module Algorand
  class BlockController < NetworkController
    layout 'tabs'

    before_action :query_date

    QUERY = <<-GRAPHQL.freeze
           query ($height: Int! $network: AlgorandNetwork!){
              algorand(network: $network ) { blocks( height: {is: $height}) { date {date} } }
           }
    GRAPHQL

    QUERY2 = <<-GRAPHQL.freeze
          query ($network: AlgorandNetwork!) {
            algorand(network: $network ) {
              blocks {
                maximum(of: block)
              }
            }
          }
    GRAPHQL

    private

    def query_date
      @block_date = Graphql::V1.query_with_retry(QUERY, variables: { height: @height.to_i,
                                                                     network: @network[:network] }, context: { authorization: @streaming_access_token }).data.algorand.blocks[0].date.date
      @is_block_section = true
    rescue StandardError
      @last_block_number = Graphql::V1.query_with_retry(QUERY2, variables: { network: @network[:network] },
                                                                context: { authorization: @streaming_access_token }).data.algorand.blocks[0].maximum
      redirect_to controller: :block, block: @last_block_number, action: params[:action]
    end
  end
end
