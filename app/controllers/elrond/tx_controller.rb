module Elrond
  class TxController < NetworkController
    layout 'tabs'

    before_action :set_transaction_hash
    before_action :breadcrumb

    def show; end

    private

    def set_transaction_hash
      @tx_hash = params[:hash]
    end

    def breadcrumb
      nil if action_name != 'show'
    end
  end
end
