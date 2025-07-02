require 'faye/websocket'
require 'eventmachine'
require 'json'
require 'securerandom'

class GraphqlWebsocketClient
  attr_reader :url, :token, :query, :variables
  
  def initialize(url, token, query, variables)
    @url = url
    @token = token
    @query = query
    @variables = variables
    @callbacks = []
    @ws = nil
    @connected = false
    @subscription_id = "1"
  end
  
  def connect(&block)
    @callbacks << block if block_given?
    
    Rails.logger.debug "[WebSocket] Starting EventMachine"
    
    Thread.new do
      EM.run do
        headers = {
          'Authorization' => @token,
          'X-API-KEY' => @token.gsub(/^Bearer\s*/, '').strip
        }
        
        @ws = Faye::WebSocket::Client.new(@url, ['graphql-ws'], headers: headers)
        
        @ws.on :open do |event|
          @connected = true
          
          init_message = { type: 'connection_init' }
          @ws.send(JSON.generate(init_message))
        end
        
        @ws.on :message do |event|
          handle_message(event.data)
        end
        
        @ws.on :close do |event|
          Rails.logger.debug "[WebSocket] Connection closed: #{event.code} #{event.reason}"
          @connected = false
          
          @callbacks.each do |callback|
            callback.call({ error: "WebSocket closed: #{event.reason}" })
          end
          
          EM.stop
        end
        
        @ws.on :error do |event|
          Rails.logger.error "[WebSocket] Error: #{event.message}"
          @connected = false
          
          @callbacks.each do |callback|
            callback.call({ error: "WebSocket error: #{event.message}" })
          end
        end
      end
    end
    
    sleep 0.1 while !@connected && @ws
  end
  
  def close
    @connected = false
    if @ws
      EM.schedule { @ws.close }
    end
  end
  
  def connected?
    @connected
  end
  
  private
  
  def handle_message(data)
    
    begin
      message = JSON.parse(data)
    rescue JSON::ParserError => e
      Rails.logger.error "[WebSocket] Failed to parse message: #{e.message}"
      return
    end
    
    case message['type']
    when 'connection_ack'
      send_subscription
    when 'data'
      payload = message['payload']
      
      @callbacks.each do |callback|
        callback.call(payload)
      end
    when 'ka'
    when 'error'
      Rails.logger.error "[WebSocket] Error from server: #{message['payload']}"
      @callbacks.each do |callback|
        callback.call({ error: message['payload'] })
      end
    when 'complete'
    else
      Rails.logger.warn "[WebSocket] Unknown message type: #{message['type']}"
    end
  end
  
  def send_subscription
    vars = @variables
    
    if vars.is_a?(String) && !vars.empty?
      begin
        vars = JSON.parse(vars)
      rescue JSON::ParserError
        Rails.logger.error "[WebSocket] Failed to parse variables: #{vars}"
        vars = {}
      end
    end
    
    subscription_message = {
      id: @subscription_id,
      type: 'start',
      payload: {
        query: @query,
        variables: vars
      }
    }
    
    @ws.send(JSON.generate(subscription_message))
  end
end