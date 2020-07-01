class Ethereum::NetworkController < ::NetworkController
  layout 'tabs'

  before_action :breadcrumb

  def blocks
    render "#{@network[:protocol]}/network/blocks" if @network[:protocol]
  end

  def miners
    render "#{@network[:protocol]}/network/miners" if @network[:protocol]
  end

  def miner_distrib
    render "#{@network[:protocol]}/network/miner_distrib" if @network[:protocol]
  end

  private
  def breadcrumb
    action_name != 'show' && @breadcrumbs << {name: t("tabs.#{controller_name}.#{action_name}.name")}
  end

end
