class Bitcoin::AddressController < ApplicationController
  def show
    @address = params[:id]
  end

end
