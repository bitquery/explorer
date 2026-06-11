class Rack::Attack
  # Aggressive SEO scrapers — block outright.
  SCRAPER_USER_AGENTS = %w[
    mj12bot
    dotbot
    exabot
    sogou
  ].freeze

  blocklist("block aggressive scrapers") do |req|
    ua = req.user_agent.to_s.downcase
    SCRAPER_USER_AGENTS.any? { |bot| ua.include?(bot) }
  end

  # Rate limits replace the old blanket bot blocklist (which matched Googlebot via "bot").
  throttle("req/ip", limit: 300, period: 5.minutes) do |req|
    req.ip unless req.path.start_with?("/assets", "/packs", "/metrics")
  end

  throttle("graphql/ip", limit: 60, period: 1.minute) do |req|
    req.ip if req.post? && req.path.match?(%r{\A/(proxy_graphql|proxy_streaming_graphql|proxy_eap_graphql)\z})
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
