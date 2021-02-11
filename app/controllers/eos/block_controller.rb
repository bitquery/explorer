class Eos::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY =  BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($height: Int!){
              eos{ blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql::Client.query(QUERY, variables: { height: @height.to_i,
                                                                    network: @network[:network] }).data.eos.blocks[0].date.date
  end
end
