module Binance
  class TokenController < NetworkController
    layout 'tabs'

    before_action :is_native

    private

    def is_native
      @token = params[:symbol]
      @native_token = @token == @network[:currency]
    end
  end
end
