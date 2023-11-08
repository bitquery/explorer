module Elrond
  class BlockController < NetworkController
    layout 'tabs'

    before_action :set_block
    before_action :query_date, only: %i[validators notarized_blocks]

    QUERY = Graphql::V1::Client.parse <<-'GRAPHQL'
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
      @block_date = Graphql::V1.instance.query_with_retry(QUERY, variables: variables, context: {'Authorization': @streaming_access_token}).data.elrond.block_validators[0].date.date
    end
  end
end
