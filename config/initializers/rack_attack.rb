class Rack::Attack
  # Search engines + social link-preview crawlers: safelisted (skip throttles & bot blocks).
  SEARCH_ENGINE_PATTERNS = [
    /googlebot/i,
    /bingbot/i,
    /duckduckbot/i,
    /applebot/i,
    /yandexbot/i,
    /baiduspider/i,
    /sogou/i,
    /petalbot/i,
    /ia_archiver/i # Internet Archive / Wayback Machine
  ].freeze

  SOCIAL_CRAWLER_PATTERNS = [
    /facebookexternalhit/i,
    /facebot/i,
    /twitterbot/i,
    /linkedinbot/i,
    /pinterestbot/i,
    /telegrambot/i,
    /slackbot/i,
    /discordbot/i,
    /whatsapp/i,
    /embedly/i
  ].freeze

  # SEO tools, AI scrapers, and aggressive harvesters — always blocked.
  BLOCKED_SCRAPER_PATTERNS = [
    /mj12bot/i,
    /dotbot/i,
    /semrushbot/i,
    /ahrefsbot/i,
    /rogerbot/i,
    /screaming[\s_-]?frog/i,
    /bytespider/i,
    /gptbot/i,
    /claudebot/i,
    /anthropic-ai/i,
    /ccbot/i,
    /dataforseo/i,
    /serpstatbot/i,
    /seokicks/i,
    /megaindex/i,
    /exabot/i,
    /blexbot/i,
    /petalsearch/i # Huawei Petal SEO spider (distinct from petalbot search crawler)
  ].freeze

  # Generic bot/scraper signatures when not safelisted above.
  GENERIC_BOT_PATTERN = /
    crawler |
    spider  |
    scraper |
    httpclient |
    libwww |
    headlesschrome |
    phantomjs |
    selenium
  /ix

  SCRIPTED_CLIENT_PATTERN = %r{
    \bcurl/   |
    \bwget/   |
    python-   |
    \bscrapy  |
    go-http-client |
    java/     |
    \bokhttp   |
    axios/    |
    node-fetch |
    httpx/    |
    ruby/     |
    perl/     |
    php/
  }ix

  class << self
    def allowed_crawler?(req)
      ua = req.user_agent.to_s
      return false if ua.strip.empty?

      SEARCH_ENGINE_PATTERNS.any? { |pattern| ua.match?(pattern) } ||
        SOCIAL_CRAWLER_PATTERNS.any? { |pattern| ua.match?(pattern) }
    end
  end

  # --- Safelist: legitimate search & social crawlers ---------------------------------

  safelist("allow search engines and social crawlers") do |req|
    allowed_crawler?(req)
  end

  # --- Blocklist: scrapers, SEO bots, scripted clients ------------------------------

  blocklist("block known scrapers") do |req|
    ua = req.user_agent.to_s
    BLOCKED_SCRAPER_PATTERNS.any? { |pattern| ua.match?(pattern) }
  end

  blocklist("block unlisted bots") do |req|
    next false if allowed_crawler?(req)

    ua = req.user_agent.to_s
    ua.match?(GENERIC_BOT_PATTERN) || ua.match?(/bot/i)
  end

  blocklist("block scripted clients") do |req|
    next false if allowed_crawler?(req)
    next false if req.path.start_with?("/metrics")

    ua = req.user_agent.to_s
    ua.strip.empty? || ua.match?(SCRIPTED_CLIENT_PATTERN)
  end

  # --- Throttles: humans & scrapers posing as browsers --------------------------------

  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    next if allowed_crawler?(req)

    req.ip unless req.path.start_with?("/assets", "/packs", "/metrics")
  end

  throttle("html burst/ip", limit: 45, period: 1.minute) do |req|
    next if allowed_crawler?(req)
    next if req.path.start_with?("/assets", "/packs", "/metrics", "/proxy_")

    req.ip
  end

  throttle("graphql/ip", limit: 60, period: 1.minute) do |req|
    next unless req.post? && req.path.match?(%r{\A/(proxy_graphql|proxy_streaming_graphql|proxy_eap_graphql)\z})
    next if allowed_crawler?(req)

    req.ip
  end

  self.blocklisted_responder = lambda do |request|
    BitqueryLogger.extra_context(
      ip: request.ip,
      user_agent: request.user_agent,
      path: request.fullpath
    )

    BitqueryLogger.warn <<~LOG
      ===== Rack::Attack ===== Blocked request:
        • IP:          #{request.ip}
        • User-Agent:  #{request.user_agent.inspect}
        • Path:        #{request.fullpath}
    LOG

    [403, { "Content-Type" => "text/plain" }, ["Forbidden"]]
  end

  self.throttled_responder = lambda do |request|
    BitqueryLogger.warn <<~LOG
      ===== Rack::Attack ===== Throttled request:
        • IP:          #{request.ip}
        • User-Agent:  #{request.user_agent.inspect}
        • Path:        #{request.fullpath}
    LOG

    [429, { "Content-Type" => "text/plain", "Retry-After" => "60" }, ["Too Many Requests"]]
  end
end
