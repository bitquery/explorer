class Bitcoin::AddressController < NetworkController
  def show
    @address = params[:id]
  end

end
