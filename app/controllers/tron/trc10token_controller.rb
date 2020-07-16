class Tron::Trc10tokenController < NetworkController
  layout 'tabs'

  before_action :token

  def transfers
    render 'tron/trc20token/transfers'
  end

  def senders
    render 'tron/trc20token/senders'
  end

  def receivers
    render 'tron/trc20token/receivers'
  end

  def trades
    render 'tron/trc20token/trades'
  end

  private
  def token
    @token = params[:address]
  end
end
