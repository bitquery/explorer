class SseConnectionManager
  MAX_CONNECTIONS = ENV.fetch('SSE_MAX_CONNECTIONS', '100').to_i
  CONNECTION_TIMEOUT = ENV.fetch('SSE_CONNECTION_TIMEOUT_MINUTES', '5').to_i.minutes

  class Connection
    attr_reader :id, :stream, :websocket_client, :created_at
    attr_accessor :last_activity

    def initialize(id, stream, websocket_client)
      @id = id
      @stream = stream
      @websocket_client = websocket_client
      @created_at = Time.current
      @last_activity = Time.current
    end

    def expired?
      Time.current - created_at > CONNECTION_TIMEOUT
    end

    def close
      Rails.logger.info "Closing connection resources for: #{@id}"
      websocket_client&.close rescue nil
      stream.close rescue nil
    end
  end

  def initialize
    @connections = {}
    @mutex = Mutex.new
    @timeout_threads = []
    @shutdown = false
  end

  def add_connection(id, stream, websocket_client)
    @mutex.synchronize do
      if @connections.size >= MAX_CONNECTIONS
        remove_oldest_connection
      end

      connection = Connection.new(id, stream, websocket_client)
      @connections[id] = connection
      connection
    end.tap do |connection|
      start_timeout_monitor(id) if connection
    end
  end

  def remove_connection(id)
    @mutex.synchronize do
      connection = @connections.delete(id)
      if connection
        Rails.logger.info "Removing SSE connection: #{id}"
        connection.close
      end
    end
  end

  def get_connection(id)
    @mutex.synchronize do
      connection = @connections[id]
      if connection
        {
          id: connection.id,
          ws_client: connection.websocket_client,
          stream: connection.stream,
          created_at: connection.created_at
        }
      end
    end
  end

  def active_connections_count
    @connections.size
  end

  def cleanup_expired_connections
    @mutex.synchronize do
      expired_ids = @connections.select { |_, conn| conn.expired? }.keys
      expired_ids.each { |id| remove_connection(id) }
    end
  end

  private

  def remove_oldest_connection
    oldest_id = @connections.min_by { |_, conn| conn.created_at }&.first
    if oldest_id
      Rails.logger.info "Removing oldest SSE connection: #{oldest_id}"
      remove_connection(oldest_id)
    end
  end

  def start_timeout_monitor(connection_id)
    thread = Thread.new do
      Thread.current[:connection_id] = connection_id
      timeout_seconds = CONNECTION_TIMEOUT.to_i
      timeout_seconds.times do
        connection_exists = @mutex.synchronize { @connections.key?(connection_id) }
        break if @shutdown || !connection_exists
        sleep 1
      end
      if !@shutdown
        @mutex.synchronize do
          if @connections[connection_id]
            Rails.logger.info "SSE connection timeout: #{connection_id}"
          end
        end
        remove_connection(connection_id) if !@shutdown
      end
    end
    @mutex.synchronize { @timeout_threads << thread }
    thread
  end
  
  def shutdown
    @shutdown = true
    @mutex.synchronize do
      @timeout_threads.each do |t| 
        t[:shutdown] = true
        t.kill rescue nil
      end
      @timeout_threads.clear
      
      @connections.each do |id, connection|
        connection.close rescue nil
      end
      @connections.clear
    end
  end
  
  def self.instance
    @instance ||= new
  end
end