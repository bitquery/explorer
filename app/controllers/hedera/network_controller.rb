module Hedera
  class NetworkController < ::NetworkController
    layout 'tabs'

    before_action :breadcrumb

    # GET hedera/transactions/:hash
    def transactions; end

    private

    def breadcrumb
      action_name != 'show' && (@breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") })
    end
  end
end
