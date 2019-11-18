class Ethereum::TokenController < NetworkController

  def show
    @address = params[:id]
  end

end
