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

  # Absolute, query-free URL for the current page. Query strings here are
  # display state -- date ranges, theme -- never distinct content.
  def canonical_url
    origin = EXPLORER_URL.presence || request.base_url
    path   = request.path.chomp('/')
    path   = '/' if path.empty?

    "#{origin.to_s.chomp('/')}#{path}"
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
