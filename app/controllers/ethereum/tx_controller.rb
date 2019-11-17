class Ethereum::TxController < ApplicationController
  def show
    @hash = params[:id]
  end

end
