class Binance::OrderController < NetworkController
  layout 'tabs'
  before_action :order_id

  private

  def order_id
    @order = params[:order]
  end
end
