class Tron::SmartContractController < Tron::AddressController

  def inflow
    render 'tron/address/inflow'
  end

  def outflow
    render 'tron/address/outflow'
  end

  def calls_contracts
    render 'tron/address/calls_contracts'
  end

  def graph
    render 'tron/address/graph'
  end

  private

  def redirect_by_type
    if !(sc = @info.try(:smart_contract))
      change_controller! 'tron/address'
    elsif sc.try(:currency)
      change_controller! 'tron/trc20token'
    end
  end

end
