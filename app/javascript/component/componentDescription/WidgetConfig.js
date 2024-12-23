export default class WidgetNetworkConfig {
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
  static getNetwork(chainId) {
    const blockchainsInfo = this.getBlockchainInfo();
    let network;
    blockchainsInfo.forEach(element => {
      if (element.chainId === chainId) {
        network = element.network;
      }
    });
    return network;
  }
  static getCurrency(chainId) {
    const blockchainsInfo = this.getBlockchainInfo();
    let currency;
    blockchainsInfo.forEach(element => {
      if (element.chainId === chainId) {
        currency = element.currency;
      }
    });
    return currency;
  }
  static getBlockProducerName(chainId) {
    const blockchainsInfo = this.getBlockchainInfo();
    let blockProducerName;
    blockchainsInfo.forEach(element => {
      if (element.chainId === chainId) {
        blockProducerName = element.blockProducerName;
      }
    });
    return blockProducerName;
  }  static getName(chainId) {
    const blockchainsInfo = this.getBlockchainInfo();
    let name;
    blockchainsInfo.forEach(element => {
      if (element.chainId === chainId) {
        name = element.name;
      }
    });
    return name;
  }
}
