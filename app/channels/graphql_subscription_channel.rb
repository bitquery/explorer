require 'net/http'
require 'uri'
require 'json'
require 'concurrent'
require_relative '../services/websocket_connection_manager'
require_relative '../services/graphql_websocket_client'

class GraphqlSubscriptionChannel < ApplicationCable::Channel
  def subscribed
    begin
      @subscription_id = params[:subscription_id]
      @heartbeat_timer = nil
      
      Rails.logger.info "[WebSocket] Client subscribed with ID: #{@subscription_id}"
      
      stream_from subscription_stream_name
      
      transmit({ 
        type: 'connection',
        connectionId: @subscription_id,
        message: 'Connected to WebSocket stream'
      })
      
      start_heartbeat
    rescue => e
      Rails.logger.error "[WebSocket] Error in subscribed: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      raise
    end
  end

  def unsubscribed
    Rails.logger.info "[WebSocket] Client unsubscribed: #{@subscription_id}"
    
    stop_heartbeat
    
    close_bitquery_connection
    
    WebSocketConnectionManager.instance.remove_connection(@subscription_id) if @subscription_id
  end

  def subscribe(data)
    handle_subscription(data)
  rescue => e
    Rails.logger.error "[WebSocket] Error in subscribe: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    transmit({ 
      type: 'error',
      error: "Error processing subscription: #{e.message}"
    })
  end
  
  def change_variables(data)
    handle_variable_change(data)
  rescue => e
    Rails.logger.error "[WebSocket] Error in change_variables: #{e.class} - #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    transmit({ 
      type: 'error',
      error: "Error changing variables: #{e.message}"
    })
  end
  
  def receive(data)
    begin
      case data['action']
      when 'subscribe'
        handle_subscription(data)
      when 'change_variables'
        handle_variable_change(data)
      else
        Rails.logger.warn "[WebSocket] Unknown action: #{data['action']}"
      end
    rescue => e
      Rails.logger.error "[WebSocket] Error in receive: #{e.class} - #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      transmit({ 
        type: 'error',
        error: "Error processing request: #{e.message}"
      })
    end
  end

  private

  def subscription_stream_name
    "graphql_subscription_#{@subscription_id}"
  end

  def handle_subscription(data)
    query = data['query']
    variables = data['variables'] || {}
    endpoint_url = data['endpoint_url']
    
    oauth_token = get_oauth_token
    
    if oauth_token.blank?
      Rails.logger.error "[WebSocket] No OAuth token available!"
      transmit({ 
        type: 'error',
        error: 'Authentication failed - no token available'
      })
      return
    end
    
    ws_url = build_websocket_url(endpoint_url, oauth_token)
    
    @ws_client = GraphqlWebsocketClient.new(
      ws_url,
      oauth_token,
      query,
      variables
    )
    
    WebSocketConnectionManager.instance.add_connection(
      @subscription_id,
      connection,
      @ws_client
    )
    
    @ws_client.connect do |bitquery_data|
      if bitquery_data[:error]
        transmit({ 
          type: 'error',
          error: bitquery_data[:error]
        })
      else
        transmit({ 
          type: 'data',
          data: bitquery_data
        })
      end
    end
  rescue => e
    Rails.logger.error "[WebSocket] Error in handle_subscription: #{e.message}"
    Rails.logger.error e.backtrace.join("\n")
    transmit({ 
      type: 'error',
      error: "Failed to establish WebSocket connection: #{e.message}"
    })
  end

  def handle_variable_change(data)
    new_variables = data['variables']
    
    if @ws_client
      close_bitquery_connection
      
      handle_subscription({
        'query' => data['query'],
        'variables' => new_variables,
        'endpoint_url' => data['endpoint_url']
      })
    else
      Rails.logger.warn "[WebSocket] No active connection to change variables"
    end
  end

  def close_bitquery_connection
    if @ws_client
      @ws_client.close
      @ws_client = nil
    end
  end

  def get_oauth_token
    token = StreamingTokenService.get
    if token.blank?
      Rails.logger.error "[WebSocket] No OAuth token from StreamingTokenService"
    end
    token
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
  
  def start_heartbeat
    heartbeat_interval = ENV.fetch('WEBSOCKET_HEARTBEAT_INTERVAL_SECONDS', '30').to_i
    
    @heartbeat_timer = Concurrent::TimerTask.new(execution_interval: heartbeat_interval) do
      transmit({ 
        type: 'heartbeat',
        timestamp: Time.current.to_i
      })
    end
    
    @heartbeat_timer.execute
  end
  
  def stop_heartbeat
    if @heartbeat_timer
      @heartbeat_timer.shutdown
      @heartbeat_timer = nil
    end
  end
end