class Ethereum::TokenPairController < NetworkController

  layout 'tabs'
  before_action :set_pair

  def show
  end

  private
  def set_pair
    @token1 = params[:token1]
    @token2 = params[:token2]
  end
end
