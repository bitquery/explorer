class Binance::NetworkController < ::NetworkController
  layout 'tabs'
  before_action :breadcrumb

  private

  def breadcrumb
    action_name != 'show' && @breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") }
  end
end
