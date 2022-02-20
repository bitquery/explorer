module Flow
  class TxController < NetworkController
    layout 'tabs'

    before_action :set_transaction_id
    before_action :breadcrumb

    def show; end

    private

    def set_transaction_id
      @tx_id = params[:id]
    end

    def breadcrumb
      return if action_name != 'show'
    end
  end
end


