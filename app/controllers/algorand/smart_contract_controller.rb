module Algorand
  class SmartContractController < Algorand::AddressController
    layout 'tabs'

    def inflow
      render 'algorand/address/inflow'
    end

    def outflow
      render 'algorand/address/outflow'
    end

    def money_flow
      render 'algorand/address/money_flow'
    end
  end
end
