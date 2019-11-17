class Ethereum::TokenController < ApplicationController

  def show
    @address = params[:id]
  end

end
