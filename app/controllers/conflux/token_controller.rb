class Conflux::TokenController < Conflux::AddressController

  before_action :is_native

  def smart_contract
    render 'conflux/smart_contract/show'
  end

  def methods
    render 'conflux/smart_contract/methods'
  end

  def events
    render 'conflux/smart_contract/events'
  end

  def transactions
    render 'conflux/smart_contract/transactions'
  end

  def inflow
    render 'conflux/address/inflow'
  end

  def outflow
    render 'conflux/address/outflow'
  end

  def calls_contracts
    render 'conflux/address/calls_contracts'
  end

  private

  def is_native
    @token = params[:address]
    @native_token = native_token?
    @token_info = !@native_token && @info.smartContract.currency
  end

  def native_token?
    @address == @network[:currency]
  end

  def redirect_by_type
    return if native_token?
    if !(sc = @info.try(:smartContract))
      change_controller!  'conflux/address'
    elsif !sc.try(:currency)
      change_controller! 'conflux/smart_contract'
    end
  end

end
