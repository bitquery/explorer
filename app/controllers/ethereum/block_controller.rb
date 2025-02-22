module Ethereum
  class BlockController < NetworkController
    layout 'tabs'

    before_action :query_date

    QUERY = <<-GRAPHQL.freeze
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
      response = ::Graphql::V2.query_with_retry(
        QUERY,
        variables: { height: @height, network: @network[:streaming] },
        context: { authorization: @streaming_access_token },use_eap: @network[:use_eap]
      )

      @block_date = response.data.EVM
      blocks = @block_date&.Blocks
      @block_timestamp = blocks && blocks.any? ? blocks.first.Block.Date : nil
      @is_block_section = true
    end

  end
end
