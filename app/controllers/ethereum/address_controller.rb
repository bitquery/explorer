class Ethereum::AddressController < NetworkController

  layout 'tabs/ethereum/address'

  before_action :net

  def net
    @address = params[:id]
    @query = @address
    @network = params[:network][:network]
  end

  def show
  end

  def inflow
  end

  def outflow
  end

  def calls_contracts
  end

end
