# rubocop:disable Metrics
module ApplicationHelper
  def external_image(name)
    "#{BITQUERY_IMAGES}/#{name}"
  end

  def image_pack_path(path)
    resolve_path_to_image path
  end

  def copy_text(addr, html_class = "", is_block_section:, height:, network:, block_id:)
    button_prev = ""
    button_next = ""
    if is_block_section
      prev_height = (height.to_i - 1).to_s
      next_height = (height.to_i + 1).to_s
      if %w[tezos filecoin cosmoshub].include?(network["network"])
        button_prev = link_to("&larr;".html_safe,
          url_for(controller: :height, height: prev_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe,
          url_for(controller: :height, height: next_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
      elsif ["solana"].include?(network["network"])
        prev_height = (block_id.to_i - 1).to_s
        next_height = (block_id.to_i + 1).to_s
        button_prev = link_to("&larr;".html_safe,
          url_for(controller: :block, block_id: prev_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe,
          url_for(controller: :block, block_id: next_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
        addr = block_id
      else
        button_prev = link_to("&larr;".html_safe,
          url_for(controller: :block, block: prev_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
        button_next = link_to("&rarr;".html_safe,
          url_for(controller: :block, block: next_height, action: params[:action]),
          class: "btn btn-outline-secondary btn-sm block-buttons")
      end
    end

    content_tag :span, class: "copy-text #{html_class}" do
      safe_join([
        button_prev,
        addr,
        link_to("", "javascript:void(0)", class: "fa fa-copy to-clipboard", "data-clipboard-text": addr,
          "data-toggle": "tooltip", title: "Copy"),
        button_next
      ], " ")
    end
  end

  def innovation_in_blockchain?(network)
    (network && BLOCKCHAIN_BY_NAME[network["network"]][:innovation] == true) || false
  end

  def extend_layout(layout, view_flow, &)
    layout = layout.to_s
    layout = "layouts/#{layout}" unless layout.include?("/")
    view_flow.get(:layout).replace capture(&)
    render template: layout
  end

  def top_ad
    session[:top_ads_index] ||= 0
    i = session[:top_ads_index]
    ads = current_ad(:top, :ads)
    session[:top_ads_index] = i == ads.size - 1  ? 0 : i + 1
    ads[i]
  end

  def bottom_ad
    session[:bottom_ads_index] ||= 0
    i = session[:bottom_ads_index]
    ads = current_ad(:bottom, :ads)
    session[:bottom_ads_index] = i == ads.size - 1  ? 0 : i + 1
    ads[i]
  end

  def current_ad(tag, ad_type = :ad)
    ads_path = ADS
    ad = "#{tag}#{request.fullpath}".split("/").filter_map do |p|
      next unless ads_path[p.to_sym]

      ad = ads_path[p.to_sym]
      ads_path = ads_path[p.to_sym]
      ad
    end.last

    ad ? ad[ad_type] : nil
  end

  def tab_ads(html_class = "nav-item nav-item-ad", token_info:)
    ads = current_ad(:tab, :ads)
    return unless ads

    safe_join(ads.filter_map do |ad|
      next if ad[:path_matches] && request.fullpath !~ Regexp.new(ad[:path_matches])

      path_segments = request.fullpath.split("/").reject(&:empty?)
      is_token_page = path_segments.length == 3 && path_segments[1].start_with?("token")

      if ad[:text].include?("{token_symbol}")
        next unless is_token_page && token_info&.symbol && token_info.symbol != "-"

        ad_text = ad[:text].gsub("{token_symbol}", token_info.symbol)
        ad_url = ad[:urls].sample
      else
        ad_text = ad[:text]
        ad_url = ad[:url]
      end

      tag.li(class: html_class) do
        link_to ad_url, class: "nav-link nav-link-ad", style: (ad[:bgcolor] ? "background-color: #{ad[:bgcolor]}" : ""), target: :blank do
          tag.span(ad_text) + tag.sup(class: "fas fa-ad text-second")
        end
      end
    end, "\n")
  end

  def tab_ad(html_class = "nav-item nav-item-ad")
    ad = current_ad(:tab, :ad)
    return unless ad

    tag.li(class: html_class) do
      link_to ad[:url], class: "nav-link nav-link-ad",
        style: (ad[:bgcolor] ? "background-color: #{ad[:bgcolor]}" : ""), target: :blank do
        tag.span(ad[:text]) + tag.sup(class: "fas fa-ad text-second")
      end
    end
  end

  def tab_link(name, action, network, new_tabs = [], html_class = "nav-item", data = {changeurl: true})
    tag.li(class: html_class) do
      tab_a(name, action, network, new_tabs, "nav-link", data)
    end
  end

  def tab_a(name, action, network, new_tabs = [], html_class = "nav-link", data = {changeurl: true})
    link_to(request.query_parameters.merge(action:),
      class: "#{html_class} #{params[:action] == action && "active"}", data:) do
      new_tab(name, action, network, new_tabs)
    end
  end

  def new_tab(name, action, network, new_tabs = [])
    if (new_tabs || []).include?(action) && innovation_in_blockchain?(network)
      content_tag(:span, name) + content_tag(:div, "", class: "blink blnkr bg-success")
    else
      name
    end
  end

  def locale_path_prefix
    if params[:locale]
      "/#{params[:locale]}/"
    else
      "/"
    end
  end

  def dark?(theme)
    theme == "dark"
  end

  def date_range_from_now(interval, unit = :hours)
    return ["#{params[:from]}T00:00:00.000Z", "#{params[:till]}T23:59:59.000Z"] if params[:from] && params[:till]

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
    [from.strftime("%Y-%m-%dT%H:%M:%S.000Z"), till.strftime("%Y-%m-%dT%H:%M:%S.999Z")]
  end
end
# rubocop:enable Metrics
