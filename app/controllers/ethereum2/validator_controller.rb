class Ethereum2::ValidatorController < NetworkController
  layout 'tabs'

  before_action :get_index

  private

  def get_index
    @index = params[:index]
  end
end
