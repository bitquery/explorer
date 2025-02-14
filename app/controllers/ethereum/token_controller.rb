module Ethereum
  class TokenController < Ethereum::AddressController
    before_action :is_native

    def smart_contract
      render 'ethereum/smart_contract/show'
    end

    def nft
      render 'ethereum/token/nft_smart_contract'
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
      @token = params[:address]
      @id = params[:id]
      @native_token = native_token?
      @token_info = !@native_token && @info
    end

    def native_token?
      @address == @network[:currency]
    end

    def redirect_by_type
      return if native_token? || @check_token == 'token'

      if @check_call == 'calls'
        change_controller! 'ethereum/smart_contract'
      else
        change_controller! 'ethereum/address'
      end
    end
  end
end
