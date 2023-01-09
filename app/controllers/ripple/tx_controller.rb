class Ripple::TxController < NetworkController
  layout 'tabs'

  before_action :set_hash
  before_action :breadcrumb

  private

  def set_hash
    @hash = params[:hash]
  end

  def breadcrumb
    return if action_name == 'show'
  end
end
