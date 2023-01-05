class Stellar::BlockController < NetworkController
  layout 'tabs'

  before_action :set_height
  before_action :breadcrumb

  private

  def set_height
    @height = params[:block]
  end

  def breadcrumb
    return if action_name == 'show'
  end
end
