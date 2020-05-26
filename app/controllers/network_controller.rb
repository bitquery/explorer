class NetworkController < ApplicationController

  before_action :network_params, :breadcrumbs

  private
  def breadcrumbs
    #@breadcrumbs = [
    #    {name: @network[:network], link: url_for(blockchain: @network[:network])}
    #]
  end


  def network_params
    raise "Network not defined" unless params[:network]
    @network = params[:network].kind_of?(ActionController::Parameters) ?
                   params[:network].permit(:network, :tag, :name, :family, :currency, :icon).to_h :
                   BLOCKCHAIN_BY_NAME[params[:network]]

    @id = params[:id]

    if params[:address]
      @address = @query = params[:address]
    elsif params[:block]
      @height = params[:block]
    elsif params[:hash]
      @hash = @query = params[:hash]
    end
  end

end

