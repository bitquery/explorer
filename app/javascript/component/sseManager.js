class SSEManager {
  constructor() {
    this.connections = new Map();
    this.setupNavigationHandlers();
  }

  setupNavigationHandlers() {
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) {
        console.log('Page hidden, disconnecting SSE connections');
        this.disconnectAll();
      }
    });

    window.addEventListener('beforeunload', () => {
      console.log('Page unloading, disconnecting SSE connections');
      this.disconnectAll();
    });

    window.addEventListener('pagehide', () => {
      console.log('Page hiding, disconnecting SSE connections');
      this.disconnectAll();
    });
  }

  register(sessionId, eventSource, url) {
    console.log(`Registering SSE connection: ${sessionId}`);
    this.connections.set(sessionId, { eventSource, url });
  }

  unregister(sessionId) {
    console.log(`Unregistering SSE connection: ${sessionId}`);
    this.connections.delete(sessionId);
  }

  disconnectAll() {
    if (this.connections.size === 0) return;
    
    console.log(`Disconnecting ${this.connections.size} SSE connections`);
    
    this.connections.forEach((connection, sessionId) => {
      try {
        if (connection.eventSource && connection.eventSource.readyState !== EventSource.CLOSED) {
          connection.eventSource.close();
        }
        
        const csrfToken = document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') || '';
        const data = new FormData();
        data.append('_method', 'DELETE');
        data.append('authenticity_token', csrfToken);
        
        if (navigator.sendBeacon) {
          navigator.sendBeacon(`/sse_subscriptions/${sessionId}`, data);
        } else {
          const xhr = new XMLHttpRequest();
          xhr.open('DELETE', `/sse_subscriptions/${sessionId}`, false);
          xhr.setRequestHeader('X-CSRF-Token', csrfToken);
          try {
            xhr.send();
          } catch (e) {
            console.error('Failed to send disconnect notification:', e);
          }
        }
      } catch (error) {
        console.error(`Error disconnecting session ${sessionId}:`, error);
      }
    });
    
    this.connections.clear();
  }

  getActiveCount() {
    return this.connections.size;
  }
}

export const sseManager = new SSEManager();