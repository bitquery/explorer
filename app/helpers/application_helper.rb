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

  def innovation_in_blockchain?
    @network && BLOCKCHAIN_BY_NAME[@network['network']][:innovation] == true || false
  end

  def extend_layout(layout, &block)
    layout = layout.to_s
    # If there's no directory component, presume a plain layout name
    layout = "layouts/#{layout}" unless layout.include?('/')
    # Capture the content to be placed inside the extended layout
    @view_flow.get(:layout).replace capture(&block)
    render file: layout
  end

  def current_ad(tag, ad_type = :ad)
    ads_path = ADS
    ad = "#{tag}#{request.fullpath}".split('/').collect { |p|
      next unless ads_path[p.to_sym]
  
      ad = ads_path[p.to_sym]
      ads_path = ads_path[p.to_sym]
      ad
    }.compact.reverse.first
  
    ad ? ad[ad_type] : nil
  end

  def tab_ads html_class = 'nav-item nav-item-ad'
    if ads = current_ad(:tab, :ads)
      ads.collect {|ad|
        tag.li(class: html_class) do
          link_to ad[:url], class: "nav-link nav-link-ad", style: (ad[:bgcolor] ? "background-color: #{ad[:bgcolor]}" : ''), target: :blank do
            "#{ad[:text]} <sup class='fas fa-ad text-second'></sup>".html_safe
          end
        end
      }.join("\n").html_safe
    end
  end

  def tab_ad html_class = 'nav-item nav-item-ad'
    if ad = current_ad(:tab, :ad)
      tag.li(class: html_class) do
        link_to ad[:url], class: "nav-link nav-link-ad", style: (ad[:bgcolor] ? "background-color: #{ad[:bgcolor]}" : ''), target: :blank do
          "#{ad[:text]} <sup class='fas fa-ad text-second'></sup>".html_safe
        end
      end
    end
  end

  def tab_link(name, action, new_tabs = [], html_class = 'nav-item', data = { changeurl: true })
    tag.li(class: html_class) do
      tab_a(name, action, new_tabs, 'nav-link', data)
    end
  end

  def tab_a(name, action, new_tabs = [], html_class = 'nav-link', data = { changeurl: true })
    link_to request.query_parameters.merge(action: action),
            class: "#{html_class} #{params[:action] == action && 'active'}", data: data do
      new_tab(name, action, new_tabs)
    end
  end

  def new_tab name, action, new_tabs = []
    (new_tabs || []).include?(action) && innovation_in_blockchain? ? tag.span(name) + " " + tag.div(class: "blink blnkr bg-success") : name
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

  def date_range_from_now(interval, unit = :hours)
    till = Time.now.utc
    from = case unit
          when :days
            till - interval.days
          when :hours
            till - interval.hours
          when :minutes
            till - interval.minutes
          else
            raise ArgumentError, "Unit must be :days, :hours, or :minutes"
          end
    [from.strftime('%Y-%m-%dT%H:%M:%S.000Z'), till.strftime('%Y-%m-%dT%H:%M:%S.000Z')]
  end

end
