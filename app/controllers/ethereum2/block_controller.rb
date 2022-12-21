class Ethereum2::BlockController < NetworkController
  layout 'tabs'

  before_action :breadcrumb, :get_block

  def validators
    # @validators = @block.validators

  end

  private

  def get_block
    @height = params[:block]
  end

  def breadcrumb

  end
end
