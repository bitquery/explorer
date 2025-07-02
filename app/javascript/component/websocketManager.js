import { createConsumer } from "@rails/actioncable"

class WebSocketManager {
  constructor() {
    this.connections = new Map();
    this.consumer = null;
    this.setupNavigationHandlers();
  }

  setupNavigationHandlers() {
    document.addEventListener('visibilitychange', () => {
      if (document.hidden) {
        console.log('Page hidden, disconnecting WebSocket connections');
        this.disconnectAll();
      }
    });

    window.addEventListener('beforeunload', () => {
      console.log('Page unloading, disconnecting WebSocket connections');
      this.disconnectAll();
    });

    window.addEventListener('pagehide', () => {
      console.log('Page hiding, disconnecting WebSocket connections');
      this.disconnectAll();
    });
  }

  getConsumer() {
    if (!this.consumer) {
      this.consumer = createConsumer();
    }
    return this.consumer;
  }

  createSubscription(subscriptionId, callbacks) {
    console.log(`Creating WebSocket subscription: ${subscriptionId}`);
    
    const subscription = this.getConsumer().subscriptions.create(
      {
        channel: "GraphqlSubscriptionChannel",
        subscription_id: subscriptionId
      },
      {
        connected() {
          console.log(`WebSocket connected: ${subscriptionId}`);
          callbacks.onConnected?.();
        },

        disconnected() {
          console.log(`WebSocket disconnected: ${subscriptionId}`);
          callbacks.onDisconnected?.();
        },

        received(data) {
          console.log(`WebSocket message received:`, data);
          
          switch (data.type) {
            case 'connection':
              callbacks.onConnection?.(data);
              break;
            case 'data':
              callbacks.onData?.(data.data);
              break;
            case 'error':
              callbacks.onError?.(data.error);
              break;
            case 'heartbeat':
              callbacks.onHeartbeat?.(data);
              break;
            default:
              console.warn(`Unknown message type: ${data.type}`);
          }
        },

        subscribe(query, variables, endpoint_url) {
          this.perform('subscribe', {
            action: 'subscribe',
            query: query,
            variables: variables,
            endpoint_url: endpoint_url
          });
        },

        changeVariables(query, variables, endpoint_url) {
          this.perform('change_variables', {
            action: 'change_variables',
            query: query,
            variables: variables,
            endpoint_url: endpoint_url
          });
        }
      }
    );

    this.connections.set(subscriptionId, subscription);
    return subscription;
  }

  unregister(subscriptionId) {
    console.log(`Unregistering WebSocket subscription: ${subscriptionId}`);
    const subscription = this.connections.get(subscriptionId);
    if (subscription) {
      subscription.unsubscribe();
      this.connections.delete(subscriptionId);
    }
  }

  disconnectAll() {
    if (this.connections.size === 0) return;
    
    console.log(`Disconnecting ${this.connections.size} WebSocket connections`);
    
    this.connections.forEach((subscription, subscriptionId) => {
      try {
        subscription.unsubscribe();
      } catch (error) {
        console.error(`Error disconnecting subscription ${subscriptionId}:`, error);
      }
    });
    
    this.connections.clear();
    
    if (this.consumer) {
      this.consumer.disconnect();
      this.consumer = null;
    }
  }

  getActiveCount() {
    return this.connections.size;
  }
}

export const websocketManager = new WebSocketManager();