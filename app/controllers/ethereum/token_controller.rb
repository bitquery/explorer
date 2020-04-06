class Ethereum::TokenController < NetworkController
  layout 'tabs'

  
  def smart_contract
    render 'ethereum/smart_contract/show'
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

end
