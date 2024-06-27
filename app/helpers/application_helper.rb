module ApplicationHelper
  def external_image(name)
    "#{BITQUERY_IMAGES}/#{name}"
  end

  def image_pack_path(path)
    resolve_path_to_image path
  end

  def copy_text(addr, html_class = '')

    if @is_block_section
      prev_height = (@height.to_i - 1).to_s
      next_height = (@height.to_i + 1).to_s
      if ['tezos', 'filecoin', 'cosmoshub'].include? @network['network']
        button_prev = link_to("&larr;".html_safe, url_for(controller: :height, height: prev_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe, url_for(controller: :height, height: next_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")

      elsif ['solana'].include? @network['network']
        prev_height = (@block_id.to_i - 1).to_s
        next_height = (@block_id.to_i + 1).to_s
        button_prev = link_to("&larr;".html_safe, url_for(controller: :block, block_id: prev_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe, url_for(controller: :block, block_id: next_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")
        addr= @block_id
      else
        button_prev = link_to("&larr;".html_safe, url_for(controller: :block, block: prev_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe, url_for(controller: :block, block: next_height, action: params[:action]), class: "btn btn-outline-secondary btn-sm block-buttons")
      end
    end
    "<span class=\"copy-text #{html_class}\">#{button_prev}#{addr} <a href='javascript:void()' class=\"fa fa-copy to-clipboard\" data-clipboard-text=\"#{addr}\" data-toggle=\"tooltip\" title=\"Copy\"></a>#{button_next}</span>".html_safe
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
    render template: layout
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
      filtered_ads = ads.collect do |ad|
        if ad[:path_matches] && !(request.fullpath =~ Regexp.new(ad[:path_matches]))
          next
        end

        path_segments = request.fullpath.split('/').reject(&:empty?)
        is_token_page = path_segments.length == 3 && path_segments[1].start_with?("token")

        if ad[:text].include?('{token_symbol}')
          next unless is_token_page && @token_info && @token_info.symbol && @token_info.symbol != '-'
          ad_text = ad[:text].gsub("{token_symbol}", @token_info.symbol)
          ad_url = ad[:urls].sample
        else
          ad_text = ad[:text]
          ad_url = ad[:url]
        end

        tag.li(class: html_class) do
          link_to ad_url, class: "nav-link nav-link-ad", style: (ad[:bgcolor] ? "background-color: #{ad[:bgcolor]}" : ''), target: :blank do
            "#{ad_text} <sup class='fas fa-ad text-second'></sup>".html_safe
          end
        end
      end.compact.join("\n").html_safe
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
    if params[:from] && params[:till]
      return ["#{params[:from]}T00:00:00.000Z", "#{params[:till]}T23:59:59.000Z"]
    end
  
    till = Time.now.utc
  
    from = case unit
           when :years
             till - interval.years
           when :days
             till - interval.days
           when :hours
             till - interval.hours
           when :minutes
             till - interval.minutes
           else
             raise ArgumentError, "Unit must be :years, :days, :hours, or :minutes"
           end
  
    [from.strftime('%Y-%m-%dT%H:%M:%S.000Z'), till.strftime('%Y-%m-%dT%H:%M:%S.999Z')]
  end  

end
