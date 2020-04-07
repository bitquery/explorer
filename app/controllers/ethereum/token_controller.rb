class Ethereum::TokenController < NetworkController
  layout 'tabs'

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
    @native_token = params[:address]==@network[:currency]
  end

end
