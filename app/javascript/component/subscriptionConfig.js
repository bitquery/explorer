export const SubscriptionConfig = {
  mode: 'websocket',
  
  features: {
    websocketEnabled: true
  },
  
  getDataSource: function(token, payload) {
    return import('./helper').then(module => {
      return new module.WebSocketSubscriptionDataSource(token, payload);
    });
  },
  
  shouldUseWebSocket: function(network, variables) {
    return true;
  }
};