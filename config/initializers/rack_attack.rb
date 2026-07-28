class Rack::Attack
  # NOTE: do not build these lists with %w[] and trailing "# comments". Ruby does
  # not treat "#" as a comment inside a %w[] literal, so every comment word
  # becomes a live pattern. The previous version of this file expanded to 66
  # entries instead of the 23 it appeared to have: it blocked any User-Agent
  # containing "#", and because its first alternative was the bare string "bot"
  # it also blocked Googlebot, bingbot, DuckDuckBot, Applebot and every other
  # search crawler. Keep these as explicit, anchored Regexp objects.

  # Search engines. Matched before any generic bot detection -- these are what
  # put the explorer in search results.
  SEARCH_ENGINE_CRAWLERS = [
    /\bGooglebot\b/i,
    /\bGoogle-InspectionTool\b/i, # Search Console live URL inspection
    /\bStorebot-Google\b/i,
    /\bbingbot\b/i,
    /\bDuckDuckBot\b/i,
    /\bApplebot\b(?!-Extended)/i, # search crawler, not the AI-training variant
    /\bYandexBot\b/i,
    /\bBaiduspider\b/i,
    /\bPetalBot\b/i,
    /\bSeznamBot\b/i,
    /\bia_archiver\b/i            # Internet Archive
  ].freeze

  # Social and chat link-preview crawlers. Allowed so shared links render cards.
  SOCIAL_PREVIEW_CRAWLERS = [
    /\bfacebookexternalhit\b/i,
    /\bTwitterbot\b/i,
    /\bLinkedInBot\b/i,
    /\bPinterestbot\b/i,
    /\bTelegramBot\b/i,
    /\bSlackbot\b/i,
    /\bDiscordbot\b/i,
    /\bWhatsApp\b/i,
    /\bredditbot\b/i
  ].freeze

  ALLOWED_CRAWLERS = (SEARCH_ENGINE_CRAWLERS + SOCIAL_PREVIEW_CRAWLERS).freeze

  # AI trainers and SEO harvesters. Blocked at the application layer, mirroring
  # the Cloudflare managed robots.txt (Content-Signal: ai-train=no).
  BLOCKED_CRAWLERS = [
    /\bGPTBot\b/i,
    /\bChatGPT-User\b/i,
    /\bOAI-SearchBot\b/i,
    /\bClaudeBot\b/i,
    /\banthropic-ai\b/i,
    /\bClaude-Web\b/i,
    /\bCCBot\b/i,
    /\bBytespider\b/i,
    /\bAmazonbot\b/i,
    /\bPerplexityBot\b/i,
    /\bmeta-externalagent\b/i,
    /\bGoogle-Extended\b/i,
    /\bApplebot-Extended\b/i,
    /\bSemrushBot\b/i,
    /\bAhrefsBot\b/i,
    /\bMJ12bot\b/i,
    /\bDotBot\b/i,
    /\brogerbot\b/i,
    /\bBLEXBot\b/i,
    /\bDataForSeoBot\b/i,
    /\bserpstatbot\b/i,
    /\bMegaIndex\b/i,
    /\bScreaming\s?Frog\b/i,
    /\bExabot\b/i,
    /\bSeekportBot\b/i
  ].freeze

  # Deliberately a broad substring match, preserving the previous behaviour for
  # unrecognised automated clients. Only ever reached after ALLOWED_CRAWLERS has
  # been checked, so it can no longer catch legitimate search engines.
  GENERIC_BOT_PATTERN = /bot|crawl|spider|scrape/i

  def self.allowed_crawler?(user_agent)
    ALLOWED_CRAWLERS.any? { |pattern| user_agent.match?(pattern) }
  end

  def self.blocked_crawler?(user_agent)
    BLOCKED_CRAWLERS.any? { |pattern| user_agent.match?(pattern) }
  end

  blocklist('block ai trainers and seo harvesters') do |req|
    blocked_crawler?(req.user_agent.to_s)
  end

  blocklist('block unlisted bots') do |req|
    ua = req.user_agent.to_s

    next false if ua.empty?
    next false if allowed_crawler?(ua)

    ua.match?(GENERIC_BOT_PATTERN)
  end

  self.blocklisted_responder = lambda do |request|
    BitqueryLogger.extra_context(
      ip:         request.ip,
      user_agent: request.user_agent,
      path:       request.fullpath
    )

    BitqueryLogger.warn <<~LOG
      ===== Rack::Attack ===== Blocked bot request:
        • IP:          #{request.ip}
        • User-Agent:  #{request.user_agent.inspect}
        • Path:        #{request.fullpath}
    LOG

    [403, { 'Content-Type' => 'text/plain' }, ['Forbidden']]
  end
end
