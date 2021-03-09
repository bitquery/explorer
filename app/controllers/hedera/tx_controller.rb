module Hedera
  class TxController < NetworkController
    layout 'tabs'

    before_action :breadcrumb, only: %i[show]

    def show; end

    def inputs; end

    def outputs; end

    private

    def breadcrumb
      return unless action_name != 'show'

      @breadcrumbs << { name: "#{t("tabs.#{controller_name}.#{action_name}.name")}: #{@hash.truncate(15)}" }
    end
  end
end
