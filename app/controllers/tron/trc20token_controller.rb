class Tron::Trc20tokenController < Tron::AddressController

  before_action :is_native

  def smart_contract
    render 'tron/smart_contract/show'
  end

  def methods
    render 'tron/smart_contract/methods'
  end

  def events
    render 'tron/smart_contract/events'
  end

  def transactions
    render 'tron/smart_contract/transactions'
  end

  def inflow
    render 'tron/address/inflow'
  end

  def outflow
    render 'tron/address/outflow'
  end

  def calls_contracts
    render 'tron/address/calls_contracts'
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
      change_controller!  'tron/address'
    elsif !sc.try(:currency)
      change_controller! 'tron/smart_contract'
    end
  end

end
