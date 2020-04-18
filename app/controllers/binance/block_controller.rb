class Binance::BlockController < NetworkController
  before_action :set_block
  layout 'tabs'
  private
  def set_block
    @height = params[:block]
  end
end
