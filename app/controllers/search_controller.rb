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
      is_hash = false
      link_type = nil

      network[:blockchainAddressPattern]&.each do |pattern|
        if input.match?(pattern)
          is_address = true
          link_type = 'address'
        end
      end

      network[:txHashPattern]&.each do |pattern|
        if input.match?(pattern)
          is_hash = true
          link_type = 'tx'
        end
      end

      next if is_address && is_hash

      excluded_by_pattern = false

      network[:excludeNetworksPattern]&.each do |exclusion_pattern|
        if input.match?(exclusion_pattern)
          excluded_by_pattern = true
        end
      end

      if (is_address || is_hash) && !excluded_by_pattern
        link = "https://explorer.bitquery.io/#{network[:network]}/#{link_type}/#{input}"
        matching_networks << {
          link: link,
          icon: network[:icon],
          name: network[:name]
        }
      end

    end
    matching_networks
    #
    # if matching_networks.size == 1
    #   redirect_to matching_networks.first[:link] and return
    # end
  end

end