module Flow
  class BlockController < NetworkController
    def transactions; end

    private

    def set_block
      @height = params[:block]
    end

    def breadcrumb
      return if action_name == 'show'
    end
  end
end
