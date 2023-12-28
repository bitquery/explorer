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

  def money_flow
    render 'tron/address/money_flow'
  end

  private

  def redirect_by_type
    unless @info&.smartContract
      change_controller! 'tron/address'
      return
    end
  
    if @info.smartContract.currency && @info.smartContract.currency.tokenType == 'TRC20'
      change_controller! 'tron/trc20token'
    end
  
  end
  
end
