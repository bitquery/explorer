class Ethereum::TxController < NetworkController

  layout 'tabs'

  before_action :get_hash


  private

  def get_hash
    @hash = params[:hash]
  end

end
