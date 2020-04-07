class Ethereum::EventController < NetworkController
  before_action :set_signature

  private
  def set_signature
    @signature = params[:signature]
  end
end
