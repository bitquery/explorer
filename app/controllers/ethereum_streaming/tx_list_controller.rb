class EthereumStreaming::TxListController < NetworkController

  def calls
    @breadcrumbs << { name: t('pages.tx_list.calls.breadcrumb') }
    @contract = params[:contract]
    @caller = params[:caller]
    @method = params[:method]
  end

  def transfers
    @breadcrumbs << { name: t('pages.tx_list.transfers.breadcrumb') }
    @sender = params[:sender]
    @receiver = params[:receiver]
    @currency = params[:currency]
  end

  def events
    @breadcrumbs << { name: t('pages.tx_list.events.breadcrumb') }
    @contract = params[:contract]
    @event = params[:event]
  end

end
