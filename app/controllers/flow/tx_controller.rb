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
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.show.name")}: #{@tx_id.truncate(15)}",
                        url: "#{locale_path_prefix}#{@network[:network]}/tx/#{@tx_id}" }

      return if action_name == 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}" }
    end
  end
end

