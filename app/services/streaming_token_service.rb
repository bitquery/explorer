class StreamingTokenService
    KEY = "streaming_oauth_token_v1"
  
    def self.get
      payload = Rails.cache.read(KEY)
      if payload && payload[:expires_at].is_a?(Time) && Time.current < payload[:expires_at]
        bitquery_logger.info "[StreamingToken] REUSE; until=#{payload[:expires_at]}"
        return payload[:token]
      end
  
      cid = ENV["GRAPHQL_CLIENT_ID"]; csec = ENV["GRAPHQL_CLIENT_SECRET"]
      if cid.to_s.empty? || csec.to_s.empty?
        Rails.logger.error "[StreamingToken] MISSING ENV GRAPHQL_CLIENT_ID/SECRET"
        return payload&.dig(:token)
      end
  
      url = URI("https://oauth2.bitquery.io/oauth2/token")
      https = Net::HTTP.new(url.host, url.port); https.use_ssl = true
      req = Net::HTTP::Post.new(url)
      req["Content-Type"] = "application/x-www-form-urlencoded"
      req.body = "grant_type=client_credentials&client_id=#{cid}&client_secret=#{csec}&scope=api"
  
      res = https.request(req)
      unless res.is_a?(Net::HTTPSuccess)
        bitquery_logger.error "[StreamingToken] OAuth error: #{res.code} #{res.message}"
        return payload&.dig(:token)
      end
  
      body = JSON.parse(res.body)
      ttl = [body["expires_in"].to_i - 300, 30].max
      expires_at = Time.current + ttl.seconds
      data = { token: "Bearer #{body["access_token"]}", expires_at: expires_at }
      Rails.cache.write(KEY, data, expires_in: ttl, race_condition_ttl: 10)
      bitquery_logger.info "[StreamingToken] NEW; until=#{expires_at}"
      data[:token]
    rescue => e
      bitquery_logger.error "[StreamingToken] fetch error: #{e.class}: #{e.message}"
      payload&.dig(:token)
    end
  
    def self.payload
      Rails.cache.read(KEY)
    end
  end