class Diem::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($network: DiemNetwork!, $version: Int!){
              diem(network: $network){ blocks( version: {is: $version}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql.instance.query_with_retry(QUERY, variables: { version: @height.to_i,
                                                                    network: @network[:network] }).data.diem.blocks[0].date.date
  end

end
