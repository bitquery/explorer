module Everscale
  class NetworkController < ::NetworkController
    layout 'tabs'

    before_action :breadcrumb

    def blocks; end

    def transactions; end

    def transfers; end

    private

    def breadcrumb
      action_name != 'show' && (@breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") })
    end
  end
end
