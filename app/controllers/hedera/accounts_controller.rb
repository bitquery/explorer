module Hedera
  class AccountsController < NetworkController
    layout 'tabs'

    before_action :set_account_id
    before_action :breadcrumb

    def show; end

    def inputs_transactions; end

    def outputs_tranasctions; end

    private

    def set_account_id
      @account_id = params[:account_id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.show.name")}: #{@account_id.truncate(15)}",
                        url: "#{@network[:network]}/accounts/#{@account_id}" }

      return if action_name == 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}" }
    end
  end
end
