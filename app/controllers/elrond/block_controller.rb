module Elrond
  class BlockController < NetworkController
    layout 'tabs'

    before_action :set_block
    before_action :query_date, only: %i[validators notarized_blocks]

    QUERY = <<-'GRAPHQL'
             query ($blockHash: String! $network: ElrondNetwork!){
                elrond(network: $network ) { blockValidators( blockHash: {is: $blockHash}) { date {date} } }
             }
    GRAPHQL

    def show; end

    def miniblocks; end

    def transactions; end

    def validators; end

    def notarized_blocks; end

    private

    def set_block
      @block_hash = params[:hash]
    end

    def breadcrumb
      return unless action_name != 'show'
    end

    def query_date
      variables = { blockHash: @block_hash.to_s,
                    network: @network[:network] }
      @block_date = Graphql::V1.query_with_retry(QUERY, variables: variables, context: { authorization: @streaming_access_token }).data.elrond.blockValidators[0].date.date
    end
  end
end
