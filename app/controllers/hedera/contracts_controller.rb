module Hedera
  class ContractsController < NetworkController
    layout 'tabs'

    before_action :set_contract_id
    before_action :breadcrumb

    def show; end

    private

    def set_contract_id
      @contract_id = params[:contract_id]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@contract_id.truncate(15)}" }
    end
  end
end
