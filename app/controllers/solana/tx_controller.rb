module Solana
  class TxController < NetworkController
    layout 'tabs'

    before_action :set_tx_hash


    private

    def set_tx_hash
      @tx_hash = params[:hash]
    end

    def breadcrumb
      return if action_name == 'show'
    end
  end
end

