class Ethereum::SmartContractController < Ethereum::AddressController
  def inflow
    render 'ethereum/address/inflow'
  end

  def outflow
    render 'ethereum/address/outflow'
  end

  def calls_contracts
    render 'ethereum/address/calls_contracts'
  end

  def money_flow
    render 'ethereum/address/money_flow'
  end

  private

  def redirect_by_type
    if !(sc = @info.try(:smart_contract))
      change_controller! 'ethereum/address'
    elsif sc.try(:currency)
      change_controller! 'ethereum/token'
    end
  end
end
