module Everscale
  class BlockController < NetworkController
    before_action :set_block_variables
    before_action :breadcrumb

    private

    def set_block_variables
      @hash = params[:hash]
      @graphql_fields = set_graphql_fields
      @is_block_section = true
    end

    def set_graphql_fields
      block_type = params[:blockType]

      return 'blockHash: {is: $hash} shardedBlockHash: {is: $hash}' if block_type == 'master'

      return 'shardedBlockHash: {is: $hash}' if block_type == 'sharded'

      'blockHash: {is: $hash} shardedBlockHash: {is: $hash}'
    end

    def breadcrumb
      nil if action_name == 'show'
    end
  end
end
