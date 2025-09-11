class WebSocketConnectionManager < ApplicationController
    def token
      token   = StreamingTokenService.get
      payload = StreamingTokenService.payload
      render json: {
        token: token,
        expires_at: payload&.dig(:expires_at)
      }
    end
  
    private
  
    def get_oauth_token
      StreamingTokenService.get
    end
  end
  
  # def get_streaming_access_token
  #   url = URI("https://oauth2.bitquery.io/oauth2/token")
  #   https = Net::HTTP.new(url.host, url.port)
  #   https.use_ssl = true

  #   request = Net::HTTP::Post.new(url)
  #   request["Content-Type"] = "application/x-www-form-urlencoded"
  #   request.body = "grant_type=client_credentials&client_id=#{ENV["GRAPHQL_CLIENT_ID"]}&client_secret=#{ENV["GRAPHQL_CLIENT_SECRET"]}&scope=api"
  #   response = https.request(request)

  #   if response.is_a?(Net::HTTPSuccess)
  #     body = JSON.parse(response.body)
  #     session["streaming_access_token"] = "Bearer #{body["access_token"]}"
  #     session["streaming_expires_in"] = Time.current + body["expires_in"].seconds - 5.minutes
  #     Rails.logger.info "Got new OAuth token: #{session['streaming_access_token']&.first(30)}..."
  #   else
  #     Rails.logger.error("Failed to retrieve streaming access token: #{response.inspect}")
  #   end
  # rescue => e
  #   Rails.logger.error("Error occurred while retrieving streaming access token: #{e.message}")
  # end
# end