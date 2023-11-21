class Tron::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = <<-'GRAPHQL'
           query ($height: Int!){
              tron{ blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = Graphql::V1.query_with_retry(QUERY, variables: { height: @height.to_i }, context: { authorization: @streaming_access_token }).data.tron.blocks[0].date.date
  end

end
