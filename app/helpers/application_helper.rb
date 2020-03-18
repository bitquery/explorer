module ApplicationHelper

  def external_css name
    "#{BITQUERY_PROJECT_URL}/css/#{name}"
  end

  def external_image name
    "#{BITQUERY_PROJECT_URL}/images/#{name}"
  end

  def image_pack_path path
    resolve_path_to_image path
  end

  def copy_text addr, html_class = ''
    "<span class=\"copy-text #{html_class}\">#{addr} <a href=\"javascript:void()\" class=\"fa fa-copy to-clipboard\" data-clipboard-text=\"#{addr}\"></a></span>".html_safe
  end

end
