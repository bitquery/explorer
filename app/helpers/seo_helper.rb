# frozen_string_literal: true

module SeoHelper
  def canonical_page_url
    path = request.path
    "#{CANONICAL_BASE_URL}#{path}"
  end

  def robots_meta_content
    if @noindex_entity
      "noindex,follow"
    else
      "index,follow"
    end
  end

  def page_h1_text
    return @page_h1 if @page_h1.present?
    return content_for(:title).presence if content_for?(:title)

    @breadcrumbs&.last&.dig(:name)
  end

  def breadcrumb_json_ld
    return unless @breadcrumbs&.any?

    items = @breadcrumbs.each_with_index.map do |crumb, index|
      url = crumb[:url].to_s
      url = "#{CANONICAL_BASE_URL}#{url}" unless url.start_with?("http")

      {
        "@type" => "ListItem",
        "position" => index + 1,
        "name" => crumb[:name].to_s.gsub(/<[^>]*>/, ""),
        "item" => url
      }
    end

    {
      "@context" => "https://schema.org",
      "@type" => "BreadcrumbList",
      "itemListElement" => items
    }.to_json
  end

  def website_json_ld
    {
      "@context" => "https://schema.org",
      "@type" => "WebSite",
      "name" => "Bitquery Explorer",
      "url" => CANONICAL_BASE_URL,
      "potentialAction" => {
        "@type" => "SearchAction",
        "target" => {
          "@type" => "EntryPoint",
          "urlTemplate" => "#{CANONICAL_BASE_URL}/search/{search_term_string}"
        },
        "query-input" => "required name=search_term_string"
      }
    }.to_json
  end

  def explorer_absolute_url(url_options = {})
    url_for(url_options.merge(host: CANONICAL_HOST, protocol: CANONICAL_PROTOCOL, only_path: false))
  end
end
