Rails.application.config.after_initialize do
  at_exit do
    if defined?(::WebsocketConnectionManager)
      Rails.logger.info "Shutting down WebSocket connection manager..."
      ::WebsocketConnectionManager.instance.shutdown rescue nil
    end
  end

  Thread.new do
    loop do
      sleep 60
      begin
        if defined?(::WebsocketConnectionManager)
          ::WebsocketConnectionManager.instance.cleanup_expired_connections
          Rails.logger.debug "WebSocket connection cleanup complete. Active connections: #{::WebsocketConnectionManager.instance.active_connections_count}"
        end
      rescue => e
        Rails.logger.error "Error in WebSocket connection cleanup: #{e.message}"
      end
    end
  end
end