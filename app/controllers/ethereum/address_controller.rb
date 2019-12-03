class Ethereum::AddressController < NetworkController

  def show
    @query = params[:id]
  end

end
