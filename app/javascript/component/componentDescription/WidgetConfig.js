export default class WidgetConfig {

  static getBlockchainInfo() {
    const data = [
      {
        tag: 'eth',
        chainId: '1',
        network: 'ethereum',
        name: 'Ethereum Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'ETH',
        icon: 'eth.svg',
        innovation: true
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
        innovation: true
      },
    ]
    return data
  }
  static getNetwork(chainId) {
    const blockchainsInfo = WidgetConfig.getBlockchainInfo();
    let network
    blockchainsInfo.forEach(element => {
      if (element.chainId === chainId) {
        network = element.network
      }
    })
    return network
  }
}