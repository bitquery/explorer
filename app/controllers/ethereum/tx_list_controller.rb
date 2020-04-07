class Ethereum::TxListController < NetworkController

  def calls
    @contract = params[:contract]
    @caller = params[:caller]
    @method = params[:method]
  end

  def transfers
    @sender = params[:sender]
    @receiver = params[:receiver]
    @currency = params[:currency]
  end

  def events
    @contract = params[:contract]
    @method = params[:method]
  end

end
