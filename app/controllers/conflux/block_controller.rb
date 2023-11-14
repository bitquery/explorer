class Conflux::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
           query ($hash: String!, $network: ConfluxNetwork!){
              conflux(network: $network ) { blocks( blockHash: {is: $hash}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = Graphql::V1.instance.query_with_retry(QUERY, variables: { hash: @hash,
                                                                    network: @network[:network] }, context: {'Authorization': @streaming_access_token}).data.conflux.blocks[0].date.date
  end

end
