class Libra::TokenController < NetworkController
  layout 'tabs'
  before_action :is_native


  private

  def is_native
    @token = params[:address]
    @native_token = native_token?
  end

  def native_token?
    @address == @network[:currency]
  end

end
