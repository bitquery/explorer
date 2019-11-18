class Ethereum::TxController < NetworkController

  def show
    @hash = params[:id]
  end

end
