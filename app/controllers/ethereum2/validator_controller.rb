class Ethereum2::ValidatorController < NetworkController
  layout 'tabs'

  before_action :get_index

  private

  def get_index
    @index = params[:index]
  end

  def breadcrumb
    @breadcrumbs << { name: t("tabs.#{controller_name}.#{action_name}.name") }
  end
end
