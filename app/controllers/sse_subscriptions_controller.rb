class SseSubscriptionsController < ApplicationController
  include ActionController::Live
  
  @@sessions = {}
  @@sessions_mutex = Mutex.new
  @@shutdown = false
  @@cleanup_thread = nil
  @@active_websockets = []
  @@websockets_mutex = Mutex.new
  
  @@cleanup_thread = Thread.new do
    until @@shutdown
      60.times do
        break if @@shutdown
        sleep 1
      end
      @@sessions_mutex.synchronize do
        @@sessions.delete_if { |_, data| Time.current - data[:created_at] > 1.minute }
      end unless @@shutdown
    end
  end
  
  at_exit do
    @@shutdown = true
    @@websockets_mutex.synchronize do
      @@active_websockets.each do |ws|
        ws.close rescue nil
      end
      @@active_websockets.clear
    end
    @@cleanup_thread&.join(1)
  end

  def create
    session_id = SecureRandom.uuid
    
    variables = params[:variables]
    
    if variables.is_a?(ActionController::Parameters)
      variables = variables.permit!.to_h
    elsif variables.is_a?(String) && !variables.empty?
      begin
        variables = JSON.parse(variables)
      rescue JSON::ParserError
        variables = {}
      end
    elsif variables.nil?
      variables = {}
    end
    
    variables = variables.is_a?(Hash) ? variables.deep_stringify_keys : {}
    
    subscription_data = {
      query: params[:query],
      variables: variables,
      endpoint_url: params[:endpoint_url],
      created_at: Time.current
    }
    
    @@sessions_mutex.synchronize do
      @@sessions[session_id] = subscription_data
    end
    
    render json: { sessionId: session_id }
  end

  def stream
    session_id = params[:id]
    
    subscription_data = nil
    @@sessions_mutex.synchronize do
      subscription_data = @@sessions.delete(session_id)
    end
    
    unless subscription_data
      render json: { error: 'Invalid or expired session' }, status: :not_found
      return
    end
    
    connection_id = SecureRandom.uuid
    
    response.headers['Content-Type'] = 'text/event-stream'
    response.headers['Cache-Control'] = 'no-cache'
    response.headers['X-Accel-Buffering'] = 'no'
    response.headers['Last-Modified'] = Time.now.httpdate
    
    oauth_token = get_oauth_token
    Rails.logger.info "Using OAuth token: #{oauth_token&.first(20)}..."
    
    ws_url = build_websocket_url(subscription_data[:endpoint_url], oauth_token)
    
    Rails.logger.info "Subscription data: #{subscription_data.inspect}"
    Rails.logger.info "Variables type: #{subscription_data[:variables].class}"
    Rails.logger.info "Variables content: #{subscription_data[:variables].to_json}"
    
    ws_client = GraphqlWebsocketClient.new(
      ws_url,
      oauth_token,
      subscription_data[:query],
      subscription_data[:variables]
    )
    
    @@websockets_mutex.synchronize do
      @@active_websockets << ws_client
    end
    
    sse = SSE.new(response.stream, event: 'message')
    
    connection = SseConnectionManager.instance.add_connection(
      connection_id, 
      response.stream,
      ws_client
    )
    
    sse.write({ 
      type: 'connection',
      connectionId: connection_id,
      message: 'Connected to SSE stream'
    })
    
    ws_client.connect do |data|
      if data[:error]
        sse.write({ 
          type: 'error',
          error: data[:error]
        })
      else
        sse.write({ 
          type: 'data',
          data: data
        })
      end
      
      connection.last_activity = Time.current if connection
    end
    
    heartbeat_thread = Thread.new do
      Thread.current.report_on_exception = false
      heartbeat_interval = ENV.fetch('SSE_HEARTBEAT_INTERVAL_SECONDS', '30').to_i
      loop do
        break unless SseConnectionManager.instance.get_connection(connection_id)
        
        begin
          sse.write({ type: 'heartbeat', timestamp: Time.current.to_i })
          heartbeat_interval.times do
            break if @@shutdown
            sleep 1
          end
        rescue IOError, Errno::EPIPE, Errno::ECONNRESET, Errno::ECONNABORTED, ActionController::Live::ClientDisconnected => e
          Rails.logger.debug "Heartbeat detected disconnect: #{e.class}"
          break
        end
        break if @@shutdown
      end
    end
    
    monitor_thread = Thread.new do
      Thread.current.report_on_exception = false
      loop do
        break if @@shutdown
        begin
          if response.stream.closed?
            Rails.logger.debug "Stream closed detected for connection: #{connection_id}"
            break
          end
          sleep 1
        rescue => e
          Rails.logger.debug "Monitor thread ended: #{e.class}"
          break
        end
      end
    end
    
    [heartbeat_thread, monitor_thread].each(&:join)
    
  rescue IOError, Errno::EPIPE, Errno::ECONNRESET, Errno::ECONNABORTED, ActionController::Live::ClientDisconnected => e
    Rails.logger.info "SSE client disconnected (#{e.class}): #{connection_id} - #{e.message}"
  ensure
    Rails.logger.info "Cleaning up connection: #{connection_id}"
    heartbeat_thread&.kill
    monitor_thread&.kill
    if ws_client
      ws_client.close
      @@websockets_mutex.synchronize do
        @@active_websockets.delete(ws_client)
      end
    end
    SseConnectionManager.instance.remove_connection(connection_id)
    sse&.close
    response.stream.close rescue nil
  end
  
  def destroy
    session_id = params[:id]
    
    connection = SseConnectionManager.instance.get_connection(session_id)
    if connection
      Rails.logger.info "Client requested disconnect for session: #{session_id}"
      
      if connection[:ws_client]
        connection[:ws_client].close rescue nil
      end
      
      SseConnectionManager.instance.remove_connection(session_id)
      
      head :ok
    else
      Rails.logger.warn "Destroy called for non-existent session: #{session_id}"
      head :not_found
    end
  end
  
  private
  
  def get_oauth_token
    if session['streaming_access_token'].present? && Time.current < session['streaming_expires_in']
      session['streaming_access_token']
    else
      get_streaming_access_token
      session['streaming_access_token']
    end
  end
  
  def get_streaming_access_token
    url = URI("https://oauth2.bitquery.io/oauth2/token")
    https = Net::HTTP.new(url.host, url.port)
    https.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["Content-Type"] = "application/x-www-form-urlencoded"
    request.body = "grant_type=client_credentials&client_id=#{ENV["GRAPHQL_CLIENT_ID"]}&client_secret=#{ENV["GRAPHQL_CLIENT_SECRET"]}&scope=api"
    response = https.request(request)

    if response.is_a?(Net::HTTPSuccess)
      body = JSON.parse(response.body)
      session["streaming_access_token"] = "Bearer #{body["access_token"]}"
      session["streaming_expires_in"] = Time.current + body["expires_in"].seconds - 5.minutes
      Rails.logger.info "Got new OAuth token: #{session['streaming_access_token']&.first(30)}..."
    else
      Rails.logger.error("Failed to retrieve streaming access token: #{response.inspect}")
      api_key = ENV.fetch('EXPLORER_API_KEY', nil)
      session["streaming_access_token"] = "Bearer #{api_key}" if api_key
    end
  rescue => e
    Rails.logger.error("Error occurred while retrieving streaming access token: #{e.message}")
    api_key = ENV.fetch('EXPLORER_API_KEY', nil)
    session["streaming_access_token"] = "Bearer #{api_key}" if api_key
  end
  
  def build_websocket_url(endpoint_url, oauth_token)
    token_value = oauth_token.to_s.gsub(/^Bearer\s*/, '').strip
    
    is_eap = endpoint_url.include?('/eap')
    
    if ENV['BITQUERY_STREAMING_WS'].present? && !is_eap
      ws_url = ENV['BITQUERY_STREAMING_WS']
    elsif ENV['BITQUERY_EAP_WS'].present? && is_eap
      ws_url = ENV['BITQUERY_EAP_WS']
    else
      ws_url = endpoint_url.gsub(/^http/, 'ws')
    end
    
    "#{ws_url}?token=#{token_value}"
  end
end