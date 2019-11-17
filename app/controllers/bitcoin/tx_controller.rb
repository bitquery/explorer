class Bitcoin::TxController < ApplicationController
  def show
    @hash = params[:id]
  end
end
