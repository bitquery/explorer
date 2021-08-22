class Cardano::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($height: Int! $network: CardanoNetwork!){
              cardano(network: $network ) { blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql::Client.query(QUERY, variables: { height: @height.to_i,
                                                                    network: @network[:network] }).data.cardano.blocks[0].date.date
  rescue Net::ReadTimeout => e
    Raven.capture_exception e
    sleep(1)
    retry
  end
end
