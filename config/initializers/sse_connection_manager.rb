Rails.application.config.after_initialize do
  $sse_cleanup_thread = Thread.new do
    Thread.current[:shutdown] = false
    5.times do
      break if Thread.current[:shutdown]
      sleep 1
    end
    
    until Thread.current[:shutdown]
      begin
        require_dependency 'sse_connection_manager'
        
        SseConnectionManager.instance.cleanup_expired_connections
        60.times do
          break if Thread.current[:shutdown]
          sleep 1
        end
      rescue => e
        Rails.logger.error "SSE connection cleanup error: #{e.message}" if defined?(Rails.logger)
        60.times do
          break if Thread.current[:shutdown]
          sleep 1
        end
      end
    end
  end
end

Signal.trap("INT") do
  if defined?($sse_cleanup_thread)
    $sse_cleanup_thread[:shutdown] = true
  end
  
  if defined?(SseConnectionManager)
    SseConnectionManager.instance.shutdown rescue nil
  end
  
  if defined?(SseSubscriptionsController)
    SseSubscriptionsController.class_eval do
      @@shutdown = true
      @@websockets_mutex.synchronize do
        @@active_websockets.each { |ws| ws.close rescue nil }
        @@active_websockets.clear
      end
    end
  end
  
  Process.kill("TERM", Process.pid)
end

at_exit do
  if defined?($sse_cleanup_thread)
    $sse_cleanup_thread[:shutdown] = true
    $sse_cleanup_thread.join(1)
  end
  
  if defined?(SseConnectionManager)
    SseConnectionManager.instance.shutdown rescue nil
  end
end