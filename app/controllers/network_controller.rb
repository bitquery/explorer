class NetworkController < ApplicationController
  before_action :network_params, :breadcrumbs

  private

  def breadcrumbs
    @breadcrumbs = [
      { name: 'Blockchains', url: locale_path_prefix },
      { name: @network[:name], url: "#{locale_path_prefix}#{@network[:network]}" },
      (if params[:address]
         { name: "#{t("tabs.#{controller_name}.show.name")}: #{params[:address].truncate(15)}",
           url: "#{locale_path_prefix}#{@network[:network]}/#{params[:address]}" }
       end),
      (if params[:block]
         { name: "#{t("tabs.#{controller_name}.show.name")}: #{params[:block].truncate(15)}",
           url: "#{locale_path_prefix}#{@network[:network]}/#{params[:block]}" }
       end),
      (if params[:hash]
         { name: "#{t("tabs.#{controller_name}.show.name")}: #{params[:hash].truncate(15)}",
           url: "#{locale_path_prefix}#{@network[:network]}/#{params[:hash]}" }
       end),
      (if (params[:address] || params[:block] || params[:hash]) && action_name != 'show'
         {
           name: t("tabs.#{controller_name}.#{action_name}.name"), url: "#{locale_path_prefix}#{@network[:network]}/#{params[:hash]}"
         }
       end)
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
    raise 'Network not defined' unless params[:network]

    @network = if params[:network].is_a?(ActionController::Parameters)
                 params[:network].permit(:network, :tag, :name, :family, :currency, :icon).to_h
               else
                 BLOCKCHAIN_BY_NAME[params[:network]]
               end

    @id = params[:id]

    if params[:address]
      @address = @query = params[:address]
    elsif params[:block] || params[:height]
      @height = params[:block] || params[:height]
    elsif params[:hash]
      @hash = @query = params[:hash]
    end
  end
end
