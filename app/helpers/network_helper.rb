module NetworkHelper

  def network_icon_path network
    network[:icon].starts_with?('currency') ? asset_path(network[:icon]) : image_pack_path("media/icon/#{network[:icon]}")
  end

  def network_icon network, options = {}
    image_tag network_icon_path(network), { alt: network[:name] }.merge(options)
  end

  def dataset_icon dataset, size = 30
    "<i class='#{dataset[:icon]}' style='font-size: #{size}px;'></i>".html_safe
  end
end
