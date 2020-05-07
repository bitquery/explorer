module NetworkHelper

  def network_icon network
    path = network[:icon].starts_with?('currency') ? network[:icon] : image_pack_path("media/icon/#{network[:icon]}")
    image_tag path, { alt: network[:name], width: '32px', height: '32px', background_color: 'white'}
  end

  def dataset_icon dataset, size = 30
    "<i class='#{dataset[:icon]}' style='font-size: #{size}px;'></i>".html_safe
  end
end
