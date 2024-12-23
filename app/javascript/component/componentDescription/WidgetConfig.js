export default class WidgetConfig {
  static getBlockchainInfo() {
    return [
      {
        tag: 'eth',
        chainId: '1',
        network: 'ethereum',
        name: 'Ethereum Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'ETH',
        icon: 'eth.svg',
        innovation: true,
        blockProducerName: 'Validator',
      },
      {
        tag: 'bsc',
        network: 'bsc',
        chainId: '56',
        name: 'Binance Smart Chain Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'BNB',
        icon: 'bnb.svg',
        start: Date.parse('2020-08-29'),
        innovation: true,
        blockProducerName: 'Validator',
      },
      {
        tag: 'arbitrum',
        chainId: '42161',
        network: 'arbitrum',
        streaming: 'arbitrum',
        name: 'Arbitrum Mainnet',
        family: 'ethereum_streaming',
        platform: 'Smart Contract',
        currency: 'ETH',
        icon: 'currency/arbitrum.svg',
        blockProducerName: 'Validator',
      },
    ];
  }

  static getBlockchainMap() {
    return this.getBlockchainInfo().reduce((map, blockchain) => {
      map[blockchain.chainId] = blockchain;
      return map;
    }, {});
  }

  static getProperty(chainId, property) {
    const blockchain = this.getBlockchainMap()[chainId];
    return blockchain ? blockchain[property] : null;
  }

  static getNetwork(chainId) {
    return this.getProperty(chainId, 'network');
  }

  static getCurrency(chainId) {
    return this.getProperty(chainId, 'currency');
  }

  static getBlockProducerName(chainId) {
    return this.getProperty(chainId, 'blockProducerName');
  }

  static getName(chainId) {
    return this.getProperty(chainId, 'name');
  }
}
