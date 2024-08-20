module Elrond
  class MiniblocksController < NetworkController
    layout 'tabs'

    before_action :set_miniblock

    before_action :breadcrumb

    def show; end

    def transactions; end

    private

    def set_miniblock
      @miniblock_hash = params[:hash]
    end

    def breadcrumb
      nil if action_name == 'show'
    end
  end
end
