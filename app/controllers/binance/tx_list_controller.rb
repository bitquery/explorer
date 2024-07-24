module Binance
  class TxListController < NetworkController
    def transfers
      @sender = params[:sender]
      @receiver = params[:receiver]
      @currency = params[:currency]
    end
  end
end
