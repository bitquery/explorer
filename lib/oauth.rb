class Oauth
  attr_reader :url, :token, :expires_in
  def initialize
    @url = URI("https://oauth2.bitquery.io/oauth2/token")
  end

  def get_access_token
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&client_id=#{ENV['GRAPHQL_CLIENT_ID']}&client_secret=#{ENV['GRAPHQL_CLIENT_SECRET']}&scope=api"
    response = https.request(request)
    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      @token = body['access_token']
      @expires_in = Time.now +  body['expires_in'].seconds
    else
      nil
    end
    @token
  end

  # def token_expires?
  #   token_expires_in <= Time.now
  # end
  #
  # def token_expires_in
  #   session['streaming_expires_in']
  # end
  #
  # def token
  #   session['streaming_access_token']
  # end

  def self.get_session_streaming_token
    oauth = Oauth.new
    oauth.get_access_token

    # token
  end



end