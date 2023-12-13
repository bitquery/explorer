class SearchController < ApplicationController
  helper_method :network_finder

  def show
    if request.post?
      redirect_to search_path(params[:query], network: (params[:network] && !params[:network].empty? ? params[:network] : nil))
      return
    end

    @query = params[:query]
    @network = params[:network] && BLOCKCHAIN_BY_NAME[params[:network]]

    networks = network_finder(@query, params[:network])
    if networks.size == 1
      redirect_to networks.first[:link] and return
    end
  end

  def network_finder(input, network_name = nil)
    matching_networks = []
  
    BLOCKCHAINS.each do |network|
      next if network_name.present? && network[:network] != network_name
  
      is_address = false
      is_message_or_tx = false
      link_type = nil
  
      network[:blockchainAddressPattern]&.each do |pattern|
        is_address = true if input.match?(pattern)
      end
  
      network[:txHashPattern]&.each do |pattern|
        if input.match?(pattern)
          is_message_or_tx = true
          # fix for filecoin
          link_type = input.start_with?('bafy') ? 'message' : 'tx'
        end
      end
  
      next if is_address && is_message_or_tx
  
      excluded_by_pattern = false
      network[:excludeNetworksPattern]&.each do |exclusion_pattern|
        excluded_by_pattern = true if input.match?(exclusion_pattern)
      end
  
      if (is_address || is_message_or_tx) && !excluded_by_pattern
        link = "https://explorer.bitquery.io/#{network[:network]}/#{link_type}/#{input}"
        matching_networks << {
          link: link,
          icon: network[:icon],
          name: network[:name]
        }
      end
    end
    matching_networks
  end  

end