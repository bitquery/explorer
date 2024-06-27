module Ripple
  class TokenController < NetworkController
    layout 'tabs'

    before_action :set_token
    before_action :breadcrumb

    def show; end

    private

    def set_token
      @token = params[:address]

      @token = @network[:currency] if native_token?
    end

    def native_token?
      @token == @network[:currency]
    end

    def breadcrumb
      nil if action_name != 'show'
    end
  end
end
