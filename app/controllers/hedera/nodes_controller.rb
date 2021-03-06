module Hedera
  class NodesController < NetworkController
    layout 'tabs'

    before_action :set_node_account, only: %i[show]
    before_action :breadcrumb, only: %i[show]

    def show; end

    private

    def set_node_account
      @node_account = @query = params[:node_account]
    end

    def breadcrumb
      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@node_account.truncate(15)}" }
    end
  end
end
