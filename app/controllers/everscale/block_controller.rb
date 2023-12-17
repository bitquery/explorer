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
    def blocks
      @is_block_section = true
    end
    def set_graphql_fields
      block_type = params[:blockType]

      if block_type == 'master'
        return 'blockHash: {is: $hash} shardedBlockHash: {is: $hash}'
      end

      if block_type == 'sharded'
        return 'shardedBlockHash: {is: $hash}'
      end

      'blockHash: {is: $hash} shardedBlockHash: {is: $hash}'
    end

    def breadcrumb
      return if action_name == 'show'
    end
  end
end
