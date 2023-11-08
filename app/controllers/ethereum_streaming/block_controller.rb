class EthereumStreaming::BlockController < NetworkController
  layout 'tabs'

  before_action :query_date

QUERY = Graphql::V2::Client.parse <<-'GRAPHQL'
  query($network: evm_network, $height: String) {
    EVM(dataset: combined, network: $network) {
      Blocks(where: { Block: { Number: { eq: $height } } }, limit: { count: 10 }) {
        ChainId
        Block {
          Number
          Date
        }
      }
    }
  }
GRAPHQL

  private

  def query_date
    @block_date = Graphql::V2.instance.query_with_retry(QUERY, variables: { height: @height.to_i,
                                                                    network: @network[:streaming] }, context: {'Authorization': @streaming_access_token}).data.evm.blocks
  end

end
