module Solana
  class NetworkController < ::NetworkController
    layout 'tabs'

    before_action :breadcrumb

    # GET /solana
    def blocks; end

    private

    def breadcrumb
      action_name != 'show' && @breadcrumbs << {name: t("tabs.#{controller_name}.#{action_name}.name")}
    end
  end
end
