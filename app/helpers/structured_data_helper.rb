module StructuredDataHelper
  # JSON-LD documents for the current page.
  #
  # Everything here mirrors something already visible on the page: the
  # breadcrumb trail rendered in the navbar, and the search box in the header.
  # Structured data describing content a visitor cannot see is treated as spam
  # by search engines, so nothing is asserted that the page does not show.
  def structured_data_documents(breadcrumbs: nil)
    documents = []
    documents << website_structured_data if home_page?

    trail = breadcrumb_structured_data(breadcrumbs)
    documents << trail if trail

    documents
  end

  def home_page?
    request.path == '/' || request.path.match?(%r{\A/[a-z]{2}/?\z})
  end

  # Mirrors the <ol class="breadcrumb"> trail. The final crumb is the current
  # page and renders without a link, so it is listed without an item URL.
  def breadcrumb_structured_data(breadcrumbs)
    return nil if breadcrumbs.blank?

    items = breadcrumbs.each_with_index.map do |crumb, index|
      breadcrumb_list_item(crumb, index + 1, last: index == breadcrumbs.size - 1)
    end

    {
      '@context' => 'https://schema.org',
      '@type' => 'BreadcrumbList',
      'itemListElement' => items
    }
  end

  # Enables the sitelinks search box, and mirrors the search field present in
  # the header.
  def website_structured_data
    {
      '@context' => 'https://schema.org',
      '@type' => 'WebSite',
      'name' => 'Bitquery Explorer',
      'url' => "#{canonical_origin}/",
      'potentialAction' => search_action_structured_data
    }
  end

  private

  def search_action_structured_data
    {
      '@type' => 'SearchAction',
      'target' => {
        '@type' => 'EntryPoint',
        'urlTemplate' => "#{canonical_origin}/search/{search_term_string}"
      },
      'query-input' => 'required name=search_term_string'
    }
  end

  def breadcrumb_list_item(crumb, position, last:)
    item = {
      '@type' => 'ListItem',
      'position' => position,
      'name' => crumb[:name].to_s
    }

    url = last ? nil : absolute_canonical_url(crumb[:url])
    item['item'] = url if url.present?

    item
  end
end
