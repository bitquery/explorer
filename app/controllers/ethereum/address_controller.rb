class Ethereum::AddressController < NetworkController

  def show
    @address = params[:id]
  end

end
