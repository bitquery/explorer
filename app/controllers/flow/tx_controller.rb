module Flow
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
      return if action_name != 'show'

      action_name != 'show' && (@breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") })
    end
  end
end

