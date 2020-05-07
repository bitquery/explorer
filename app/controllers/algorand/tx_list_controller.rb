class Algorand::TxListController < NetworkController

  def transfers
    @sender = params[:sender]
    @receiver = params[:receiver]
    @currency = params[:currency] &&
        if params[:currency]==@network[:currency]
          0
        else
          params[:currency].to_i
        end
  end

end
