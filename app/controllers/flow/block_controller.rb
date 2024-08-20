module Flow
  class BlockController < NetworkController
    before_action :blocks

    def transactions; end

    private

    def set_block
      @height = params[:block]
    end

    def blocks
      @is_block_section = true
    end

    def breadcrumb
      nil if action_name == 'show'
    end
  end
end
