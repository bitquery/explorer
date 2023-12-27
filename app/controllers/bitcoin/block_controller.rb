class Bitcoin::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

  QUERY = <<-'GRAPHQL'
           query ($height: Int! $network: BitcoinNetwork!){
              bitcoin(network: $network ) { blocks( height: {is: $height}) { date {date} } }
           }
  GRAPHQL
  QUERY2 = <<-'GRAPHQL'
              query ( $network: BitcoinNetwork!) {
                 bitcoin(network: $network ) {
                  blocks {
                    maximum(of: block)
                  }
                }
              }
  GRAPHQL

  private

  def query_date
    @block_date = Graphql::V1.query_with_retry(QUERY, variables: { height: @height.to_i,
                                                                   network: @network[:network] }, context: { authorization: @streaming_access_token }).data.bitcoin.blocks[0].date.date
    @is_block_section = true
  rescue
    @last_block_number = Graphql::V1.query_with_retry(QUERY2, variables: { network: @network[:network] }, context: { authorization: @streaming_access_token }).data.bitcoin.blocks[0].maximum
    redirect_to controller: :block, block: @last_block_number, action: params[:action]
  end

  if @height.to_i == 666666
    BitqueryLogger.debug 'Secret debug message', height: @height.to_i
    BitqueryLogger.info 'Secret info message', height: @height.to_i
    BitqueryLogger.warn 'Secret warn message', height: @height.to_i
    BitqueryLogger.error 'Secret error message', height: @height.to_i
  end
end
