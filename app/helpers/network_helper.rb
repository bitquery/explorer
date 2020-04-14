module NetworkHelper

  def network_icon network
    image_tag image_pack_path("media/icon/#{network[:icon]}"), {class: 'mr-3', alt: network[:name]}
  end

  def dataset_icon dataset, size = 30
    "<i class='#{dataset[:icon]} mr-3' style='font-size: #{size}px;'></i>".html_safe
  end
end
