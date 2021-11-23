class Ethereum::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair

  def show
  end

  def trading_view
    @breadcrumbs << {name:'Trading view'}
  end
  def last_trades
    @breadcrumbs << {name: 'Last Trades'}
  end

  private
  def set_pair
    @token1 = params[:token1]
    @token2 = params[:token2]
  end
end
