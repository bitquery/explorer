module Ethereum
  class SmartContractController < Ethereum::AddressController
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
      return unless !@check_call == 'calls'

      change_controller! 'ethereum/address'
      # elsif @check_token = 'token'
      #   change_controller! 'ethereum/token'
    end
  end
end
