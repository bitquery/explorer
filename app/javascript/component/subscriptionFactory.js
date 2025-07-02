import { WebSocketSubscriptionDataSource } from './helper';

export class SubscriptionFactory {
  static create(token, payload, options = {}) {
    return new WebSocketSubscriptionDataSource(token, payload);
  }
}

export function createSubscriptionDataSource(token, payload, options) {
  return SubscriptionFactory.create(token, payload, options);
}