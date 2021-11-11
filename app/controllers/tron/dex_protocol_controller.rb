class Tron::DexProtocolController <  NetworkController
  before_action :set_protocol, :breadcrumb

  layout 'tabs'

  private
  def set_protocol
    @protocol = params[:protocol]
  end

  def breadcrumb
    @breadcrumbs << {name: @protocol} << {name: t("tabs.#{controller_name}.#{action_name}.name")}
  end

end
