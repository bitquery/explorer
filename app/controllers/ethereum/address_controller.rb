class Ethereum::AddressController < NetworkController

  layout 'tabs/address'

  def show
    @address = params[:id]
    @query = @address
    @network = params[:network][:network]
  end

end
