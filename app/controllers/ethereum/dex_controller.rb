class Ethereum::DexController <  NetworkController
  before_action :set_exchange

  layout 'tabs'

  private
  def set_exchange
    @exchange = params[:exchange]
  end

end
