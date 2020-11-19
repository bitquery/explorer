class Eos::SmartContractController < Eos::AddressController

  def inflow
    render 'eos/address/inflow'
  end

  def outflow
    render 'eos/address/outflow'
  end

  def calls_contracts
    render 'eos/address/calls_contracts'
  end

  def graph
    render 'eos/address/graph'
  end

  def money_flow
    render 'eos/address/money_flow'
  end

  private

  def redirect_by_type
    if !(sc = @info.try(:smart_contract))
      change_controller! 'eos/address'
    elsif sc.try(:currency)
      change_controller! 'eos/token'
    end
  end

end
