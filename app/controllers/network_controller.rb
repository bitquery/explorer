class NetworkController < ApplicationController

  before_action :network_params, :breadcrumbs

  private
  def breadcrumbs
    @breadcrumbs = [
        {name: 'Explorer', url: locale_path_prefix},
        {name: @network[:name], url: "#{locale_path_prefix}#{@network[:network]}"},
        (params[:address] ? {name: params[:address].truncate(15), url: "#{locale_path_prefix}#{@network[:network]}/#{params[:address]}"} : nil),
        (params[:block] ? {name: params[:block].truncate(15), url: "#{locale_path_prefix}#{@network[:network]}/#{params[:block]}"} : nil),
        (params[:hash] ? {name: params[:hash].truncate(15), url: "#{locale_path_prefix}#{@network[:network]}/#{params[:hash]}"} : nil),
        ((params[:address]|| params[:block] || params[:hash]) && action_name != 'show' ? {name: t("tabs.#{controller_name}.#{action_name}.name"), url: "#{locale_path_prefix}#{@network[:network]}/#{params[:hash]}"} : nil)
    ].compact
  end

  def locale_path_prefix
    if params[:locale]
      "/#{params[:locale]}/"
    else
      '/'
    end
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

