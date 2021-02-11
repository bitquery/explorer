class Diem::TxListController < NetworkController
  def transfers
    @breadcrumbs << { name: t('pages.tx_list.transfers.breadcrumb') }
    @sender = params[:sender]
    @receiver = params[:receiver]
    @currency = params[:currency]
  end
end
