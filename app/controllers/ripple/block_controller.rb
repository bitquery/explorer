module Ripple
  class BlockController < NetworkController
    layout 'tabs'

    before_action :set_height
    before_action :breadcrumb

    private

    def set_height
      @height = params[:block]
      @is_block_section = true
    end

    def breadcrumb
      nil if action_name == 'show'
    end
  end
end
