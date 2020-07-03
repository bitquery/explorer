class Conflux::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY =  BitqueryGraphql::Client.parse  <<-'GRAPHQL'
           query ($hash: String!, $network: ConfluxNetwork!){
              conflux(network: $network ) { blocks( blockHash: {is: $hash}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql::Client.query(QUERY, variables: {hash: @hash,
                                                                   network: @network[:network]}).data.conflux.blocks[0].date.date
  end

end
