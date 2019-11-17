class Ethereum::AddressController < ApplicationController

  def show
    @address = params[:id]
  end

end
