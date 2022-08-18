module Elrond
  class CallResultController < NetworkController
    layout 'tabs'

    before_action :set_call_result
    before_action :breadcrumb

    def show; end

    private

    def set_call_result
      @hash = params[:hash]
    end

    def breadcrumb
      return if action_name != 'show'
    end
  end
end


