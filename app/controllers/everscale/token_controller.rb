module Everscale
  class TokenController < NetworkController
    layout 'tabs'

    before_action :set_token_hash

    def show; end

    private

    def set_token_hash
      @token = params[:symbol]
    end
  end
end
