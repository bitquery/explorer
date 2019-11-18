class NetworkController < ApplicationController

  before_action :network_params


  private

  def network_params
    @network = params[:network]
    @address = params[:address]
    @hash = params[:hash]
  end

end
