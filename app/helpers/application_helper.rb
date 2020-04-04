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

  def extend_layout(layout, &block)
    layout = layout.to_s
    # If there's no directory component, presume a plain layout name
    layout = "layouts/#{layout}" unless layout.include?('/')
    # Capture the content to be placed inside the extended layout
    @view_flow.get(:layout).replace capture(&block)
    render file: layout
  end

  def tab_link name, action
    content_tag :li, class: 'nav-item' do
      link_to name, request.query_parameters.merge(action: action), class: "nav-link #{params[:action] == action && 'active'}"
    end
  end


  def locale_path_prefix
    if params[:locale]
      "/#{params[:locale]}/"
    else
      '/'
    end
  end

end
