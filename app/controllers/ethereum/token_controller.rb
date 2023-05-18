class Ethereum::TokenController < Ethereum::AddressController

  before_action :is_native

  def smart_contract
    render 'ethereum/smart_contract/show'
  end

  def methods
    render 'ethereum/smart_contract/methods'
  end

  def events
    render 'ethereum/smart_contract/events'
  end

  def transactions
    render 'ethereum/smart_contract/transactions'
  end

  def inflow
    render 'ethereum/address/inflow'
  end

  def outflow
    render 'ethereum/address/outflow'
  end

  def calls_contracts
    render 'ethereum/address/calls_contracts'
  end

  private

  def is_native
    @token = params[:address]
    @native_token = native_token?
    @token_info = !@native_token && @info.smart_contract.currency
  end

  def native_token?
    @address == @network[:currency]
  end

  def redirect_by_type
    return if native_token?
    if !(sc = @info.try(:smart_contract))
      change_controller!  'ethereum/address'
    elsif !sc.try(:currency)
    #  change_controller! 'ethereum/smart_contract'
    end
  end

end
