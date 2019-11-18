class Bitcoin::TxController < NetworkController
  def show
    @hash = params[:id]
    @network = params[:network]
  end
end
