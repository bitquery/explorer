class SearchController < ApplicationController
  helper_method :network_finder
  def show
    if request.post?
      redirect_to search_path(params[:query], network: (params[:network] && !params[:network].empty? ? params[:network] : nil))
    end
    @query = params[:query]
    @network = params[:network] && BLOCKCHAIN_BY_NAME[params[:network]]
  end
  def network_finder(address, network_name=nil)
    matching_networks = []

    BLOCKCHAINS.each do |network|
      next if network_name.present? && network[:network] != network_name
      matches_address_pattern = false
      excluded_by_pattern = false

      network[:blockchainAddressPattern]&.each do |pattern|
        if address.match?(pattern)
          matches_address_pattern = true
          break
        end
      end

      network[:excludeNetworksPattern]&.each do |exclusion_pattern|
        if address.match?(exclusion_pattern)
          excluded_by_pattern = true
          break
        end
      end

      if matches_address_pattern && !excluded_by_pattern
        link = "https://explorer.bitquery.io/#{network[:network]}/address/#{address}"
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