class Tron::DexController <  NetworkController
  before_action :set_exchange, :breadcrumb

  layout 'tabs'

  private
  def set_exchange
    @exchange = params[:exchange]
  end

  def breadcrumb
    @breadcrumbs << {name: @exchange} << {name: t("tabs.#{controller_name}.#{action_name}.name")}
  end

end
