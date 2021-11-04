module Elrond
  class BlockController < NetworkController
    layout 'tabs'

    before_action :set_block
    before_action :query_date, only: %i[validators notarized_blocks]

    QUERY = BitqueryGraphql::Client.parse <<-'GRAPHQL'
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
      @block_date = BitqueryGraphql::Client.query(QUERY, variables: variables).data.elrond.block_validators[0].date.date
    rescue Net::ReadTimeout => e
      Raven.capture_exception e
      sleep(1)
      retry
    end
  end
end
