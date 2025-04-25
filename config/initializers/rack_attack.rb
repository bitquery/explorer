class Rack::Attack
  BOT_USER_AGENTS = %w[
    bot
    crawler
    spider
    slurp           # Yahoo! Slurp
    yandexbot       # Яндекс
    bingbot         # Bing
    baiduspider     # Baidu
    duckduckbot     # DuckDuckGo
    facebookexternalhit
    facebot         # Facebook
    twitterbot      # Twitter
    applebot        # Applebot (Safari News)
    petalbot        # Huawei Petal
    semrushbot      # SEMrush
    ahrefsbot       # Ahrefs
    mj12bot         # Majestic
    dotbot          # Moz
    sogou           # Sogou
    exabot          # Exalead
    archive.org_bot # Wayback Machine
    linkedinbot     # LinkedIn
    pinterestbot    # Pinterest
    telegrambot     # Telegram
  ].join('|').freeze

  blocklist('block known bots') do |req|
    req.user_agent.to_s.downcase.match?(/#{BOT_USER_AGENTS}/)
  end

  self.blocklisted_response = lambda do |env|
    request = Rack::Request.new(env)

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
