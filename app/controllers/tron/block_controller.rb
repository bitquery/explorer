class Tron::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY =  BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($height: Int!){
              tron{ blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql::Client.query(QUERY,
                                                variables: { height: @height.to_i }).data.tron.blocks[0].date.date
  end
end
