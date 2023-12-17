class Eos::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = <<-'GRAPHQL'
           query ($height: Int!){
              eos{ blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = Graphql::V1.query_with_retry(QUERY, variables: { height: @height.to_i,
                                                                   network: @network[:network] }, context: { authorization: @streaming_access_token }).data.eos.blocks[0].date.date
    @is_block_section = true
  end

end
