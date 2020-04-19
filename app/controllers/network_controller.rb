class NetworkController < ApplicationController

  before_action :network_params

  private

  def network_params
    raise "Network not defined" unless params[:network]
    @network = params[:network].kind_of?(ActionController::Parameters) ?
                   params[:network].permit(:network, :tag, :name, :family, :currency, :icon).to_h :
                   BLOCKCHAIN_BY_NAME[params[:network]]

    if params[:address]
      @address = @query = params[:address]
    elsif params[:block]
      @height = params[:block]
    elsif params[:hash]
      @hash = @query = params[:hash]
    end
  end

end

