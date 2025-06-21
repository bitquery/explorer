require 'websocket-client-simple'
require 'json'
require 'securerandom'

class GraphqlWebsocketClient
  attr_reader :ws, :url, :token, :query, :variables

  def initialize(url, token, query, variables)
    @url = url
    @token = token
    @query = query
    @variables = variables
    @connected = false
    @callbacks = []
  end

  def connect(&block)
    @callbacks << block if block_given?
    
    Rails.logger.info "Attempting WebSocket connection to: #{@url}"
    
    client = self
    
    headers = {}
    if @token
      headers['Authorization'] = @token
      headers['X-API-KEY'] = @token.gsub(/^Bearer\s*/, '').strip
    end
    
    Rails.logger.info "WebSocket headers: #{headers.keys.join(', ')}"

    @ws = WebSocket::Client::Simple.connect(@url, headers: headers) do |ws|
      ws.on :open do
        Rails.logger.info "WebSocket connection opened to #{client.url}"
        client.instance_variable_set(:@connected, true)
        
        init_message = {
          type: 'connection_init'
        }
        
        ws.send(JSON.generate(init_message))
      end

      ws.on :message do |msg|
        Rails.logger.debug "Message received - Type: #{msg.type}, Data type: #{msg.data.class}"
        
        if msg.type == :text
          client.send(:handle_message, msg.data)
        else
          Rails.logger.debug "Ignoring non-text frame of type: #{msg.type}"
        end
      end

      ws.on :close do |e|
        Rails.logger.info "WebSocket connection closed: #{e}"
        client.instance_variable_set(:@connected, false)
      end

      ws.on :error do |e|
        Rails.logger.error "WebSocket error: #{e}"
        client.instance_variable_set(:@connected, false)
      end
    end
  end

  def subscribe
    return unless @connected

    @subscription_id = "1"
    
    vars = @variables || {}
    
    if vars.is_a?(String) && !vars.empty?
      begin
        vars = JSON.parse(vars)
      rescue JSON::ParserError
        Rails.logger.error "Failed to parse variables as JSON: #{vars}"
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

    Rails.logger.info "Sending subscription: #{@subscription_id}"
    Rails.logger.info "Query: #{@query}"
    Rails.logger.info "Variables type: #{vars.class}"
    Rails.logger.info "Variables content: #{vars.inspect}"
    Rails.logger.info "Full message: #{subscription_message.to_json}"
    
    @ws.send(JSON.generate(subscription_message))
  end

  def close
    Rails.logger.info "Closing WebSocket connection to #{@url}"
    @connected = false
    @ws&.close
  end

  def connected?
    @connected
  end

  private

  def handle_message(data)
    return if data.nil?
    
    data_str = data.is_a?(String) ? data : data.to_s
    
    Rails.logger.debug "Raw message: #{data_str[0..200]}... (encoding: #{data_str.encoding})"
    
    begin
      message = JSON.parse(data_str)
    rescue JSON::ParserError => e
      Rails.logger.error "Failed to parse message as JSON: #{e.message}"
      Rails.logger.error "Data (first 500 chars): #{data_str[0..500]}"
      Rails.logger.error "Data encoding: #{data_str.encoding}"
      Rails.logger.error "Data bytes: #{data_str.bytes.first(50).inspect}"
      return
    end
    
    case message['type']
    when 'connection_ack'
      Rails.logger.info "WebSocket connection acknowledged"
      subscribe
    when 'data'
      Rails.logger.info "Received data from subscription"
      Rails.logger.info "Full message: #{message.inspect}"
      Rails.logger.info "Payload class: #{message['payload'].class}"
      Rails.logger.info "Payload keys: #{message['payload'].keys if message['payload'].is_a?(Hash)}"
      Rails.logger.info "Payload structure: #{message['payload'].inspect[0..500]}..."
      
      payload = message['payload']
      if payload.is_a?(Hash) && !payload.has_key?('data')
        payload = { 'data' => payload }
      end
      
      @callbacks.each do |callback|
        callback.call(payload)
      end
    when 'ka'
      Rails.logger.debug "Keep-alive message received"
    when 'error'
      Rails.logger.error "WebSocket subscription error: #{message['payload']}"
      @callbacks.each do |callback|
        callback.call({ error: message['payload'] })
      end
    when 'complete'
      Rails.logger.info "WebSocket subscription completed"
      close
    else
      Rails.logger.debug "Unknown message type: #{message['type']}"
    end
  end
end