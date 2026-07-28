module SeoHelper
  # Entity pages expose the same record under several tab URLs -- an address
  # is reachable at /show, /transactions, /inflow, /outflow, /calls_contracts
  # and /multichain. Indexing every tab multiplies each address, transaction
  # and token by the number of tabs, on every chain, and splits ranking
  # signals across near-duplicate pages. Only the overview action is
  # indexable; the tabs stay crawlable so they still pass links onward.
  ENTITY_CONTROLLERS = %w[
    address
    tx
    token
    trc10token
    trc20token
    smart_contract
    block
  ].freeze

  INDEXABLE_ENTITY_ACTION = 'show'.freeze

  # Scheme and host every absolute URL on the page is built from.
  def canonical_origin
    (EXPLORER_URL.presence || request.base_url).to_s.chomp('/')
  end

  # Absolute, query-free URL for the current page. Query strings here are
  # display state -- date ranges, theme -- never distinct content.
  def canonical_url
    path = request.path.chomp('/')
    path = '/' if path.empty?

    "#{canonical_origin}#{path}"
  end

  # Turns a relative path from a breadcrumb or link into an absolute URL on the
  # canonical origin. Returns nil for anything that is not usable.
  def absolute_canonical_url(path)
    return nil if path.blank?
    return path if path.to_s.start_with?('http://', 'https://')

    "#{canonical_origin}/#{path.to_s.delete_prefix('/')}"
  end

  def entity_tab_page?
    ENTITY_CONTROLLERS.include?(controller_name) &&
      action_name != INDEXABLE_ENTITY_ACTION
  end

  # Emitted only when a non-default directive is needed. No tag means
  # "index, follow", so a narrow condition here cannot accidentally
  # de-index the site.
  def robots_directive
    'noindex, follow' if entity_tab_page?
  end
end
