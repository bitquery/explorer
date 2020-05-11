class Algorand::SmartContractController < NetworkController
  layout 'tabs'


  def inflow
    render 'algorand/address/inflow'
  end

  def outflow
    render 'algorand/address/outflow'
  end

end
