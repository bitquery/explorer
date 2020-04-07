class Ethereum::BlockController < NetworkController
  before_action :set_block

  private
  def set_block
    @block = params[:block]
  end
end
