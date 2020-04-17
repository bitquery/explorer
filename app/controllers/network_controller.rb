class NetworkController < ApplicationController

  before_action :network_params

  private

  def network_params
    @network = params[:network].kind_of?(ActionController::Parameters) ?
                   params[:network].permit(:network, :tag, :name, :path, :family, :currency, :icon).to_h :
                   BLOCKCHAIN_BY_NAME[params[:network]]

    if params[:address]
      @address = @query = params[:address]
    elsif params[:hash]
      @hash = @query = params[:hash]
    end
  end

end

