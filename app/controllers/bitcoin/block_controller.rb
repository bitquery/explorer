class Bitcoin::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
           query ($height: Int! $network: BitcoinNetwork!){
              bitcoin(network: $network ) { blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL

  private

  def query_date
    @block_date = BitqueryGraphql.instance.query_with_retry(QUERY, variables: { height: @height.to_i,
                                                                    network: @network[:network] }).data.bitcoin.blocks[0].date.date

    if @height.to_i == 666666
      BitqueryLogger.debug "Secret debug message", height: @height.to_i
      BitqueryLogger.info "Secret info message", height: @height.to_i
      BitqueryLogger.warn "Secret warn message", height: @height.to_i
      BitqueryLogger.error "Secret error message", height: @height.to_i
    end
  end
end
