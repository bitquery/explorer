class Algorand::SmartContractController < Algorand::AddressController
  layout 'tabs'

  def inflow
    render 'algorand/address/inflow'
  end

  def outflow
    render 'algorand/address/outflow'
  end

  def graph
    render 'algorand/address/graph'
  end

end
