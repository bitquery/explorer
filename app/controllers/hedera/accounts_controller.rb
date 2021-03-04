module Hedera
  class AccountsController < NetworkController
    layout 'tabs'

    before_action :set_account_id, only: %i[show]
    before_action :breadcrumb, only: %i[show]

    def show; end

    def inputs_transactions; end

    def outputs_tranasctions; end

    private

    def set_account_id
      @account_id = @query = params[:account_id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@account_id.truncate(15)}" }
    end
  end
end
