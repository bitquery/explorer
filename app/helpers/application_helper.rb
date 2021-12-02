module ApplicationHelper
  def external_image(name)
    "#{BITQUERY_IMAGES}/#{name}"
  end

  def image_pack_path(path)
    resolve_path_to_image path
  end

  def copy_text(addr, html_class = '')
    "<span class=\"copy-text #{html_class}\">#{addr} <a href='javascript:void()' class=\"fa fa-copy to-clipboard\" data-clipboard-text=\"#{addr}\" data-toggle=\"tooltip\" title=\"Copy\"></a></span>".html_safe
  end

  def extend_layout(layout, &block)
    layout = layout.to_s
    # If there's no directory component, presume a plain layout name
    layout = "layouts/#{layout}" unless layout.include?('/')
    # Capture the content to be placed inside the extended layout
    @view_flow.get(:layout).replace capture(&block)
    render file: layout
  end

  def tab_link(name, action, html_class = 'nav-item', data = { changeurl: true })
    tag.li(class: html_class) do
      tab_a name, action, 'nav-link', data
    end
  end

  def tab_a(name, action, html_class = 'nav-link', data = { changeurl: true })
    link_to name, request.query_parameters.merge(action: action),
            class: "#{html_class} #{params[:action] == action && 'active'}", data: data
  end

  def locale_path_prefix
    if params[:locale]
      "/#{params[:locale]}/"
    else
      '/'
    end
  end

  def dark?
    @theme == 'dark'
  end

  def limited_date_range_limit(from, till, days = nil)
    if days
      ["'#{Date.today - days}'", 'null']
    else
      [from, till]
    end
  end
end
