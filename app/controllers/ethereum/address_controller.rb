class Ethereum::AddressController < NetworkController

  def show
    @address = params[:id]
    @query = @address
    @network = params[:network][:network]
  end

end
