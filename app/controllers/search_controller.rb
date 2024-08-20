class SearchController < ApplicationController
  helper_method :network_finder

  def show
    if request.post?
      redirect_to search_path(params[:query],
                              network: params[:network].presence)
      return
    end

    @query = params[:query]
    @network = params[:network] && BLOCKCHAIN_BY_NAME[params[:network]]

    networks = network_finder(@query, params[:network])
    return unless networks.size == 1

    redirect_to networks.first[:link] and return
  end

  def network_finder(input, network_name = nil)
    matching_networks = []

    BLOCKCHAINS.each do |network|
      next if network_name.present? && network[:network] != network_name

      is_address = false
      is_message_or_tx = false
      link_type = nil

      network[:blockchainAddressPattern]&.each do |pattern|
        if input.match?(pattern)
          is_address = true
          link_type = 'address'
        end
      end

      network[:txHashPattern]&.each do |pattern|
        next unless input.match?(pattern)

        is_message_or_tx = true
        link_type = if network[:network] == 'filecoin'
                      input.start_with?('bafy') ? 'message' : 'tx'
                    else
                      'tx'
                    end
      end

      next if is_address && is_message_or_tx

      excluded_by_pattern = false
      network[:excludeNetworksPattern]&.each do |exclusion_pattern|
        excluded_by_pattern = true if input.match?(exclusion_pattern)
      end

      next unless (is_address || is_message_or_tx) && !excluded_by_pattern

      link = internal_link(network[:network], link_type, input)
      matching_networks << {
        link:,
        icon: network[:icon],
        name: network[:name]
      }
    end
    matching_networks
  end

  private

  def internal_link(network, link_type, input)
    case link_type
    when 'address'
      "/#{network}/address/#{input}"
    when 'tx'
      "/#{network}/tx/#{input}"
    when 'message'
      "/#{network}/message/#{input}"
    else
      '#'
    end
  end
end
