module Hedera
  class ContractsController < NetworkController
    layout 'tabs'

    before_action :set_contract_id, only: %i[show]
    before_action :breadcrumb, only: %i[show]

    def show; end

    private

    def set_contract_id
      @contract_id = @query = params[:contract_id]
    end

    def breadcrumb
      return unless action_name != 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@hash.truncate(15)}" }
    end
  end
end
