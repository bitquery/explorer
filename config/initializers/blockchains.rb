BLOCKCHAINS = [
  {
    tag: 'btc',
    network: 'bitcoin',
    name: 'Bitcoin Mainnet',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'BTC',
    icon: 'btc.svg',
    blockchainAddressPattern: ['([\\W]|^)(bc1[\\da-zA-Z]{39,59})([\\W]|$)',
                               '([\\W]|^)([3,1][\\da-zA-Z]{32,34})([\\W]|$)', '([\\W]|^)([m,d]-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']

  },
  {
    tag: 'ltc',
    network: 'litecoin',
    name: 'Litecoin',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'LTC',
    icon: 'ltc.svg',
    blockchainAddressPattern: ['([\\W]|^)([L,M][\\da-zA-Z]{33})([\\W]|$)',
                               '([\\W]|^)(ltc1[\\da-zA-Z]{39,59})([\\W]|$)', '([\\W]|^)([m,d]-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'doge',
    network: 'dogecoin',
    name: 'Dogecoin',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'DOGE',
    icon: 'doge.svg',
    blockchainAddressPattern: ['([\\W]|^)([9,A,D][\\da-zA-Z]{33})([\\W]|$)', '([\\W]|^)(d-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'dash',
    network: 'dash',
    name: 'Dash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'DASH',
    icon: 'dash.svg',
    blockchainAddressPattern: ['([\\W]|^)([7,X][\\da-zA-Z]{33})([\\W]|$)', '([\\W]|^)(d-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'eth',
    chainId: '1',
    network: 'ethereum',
    streaming: 'eth',
    name: 'Ethereum Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'ETH',
    nativeToken:'0x',
    icon: 'eth.svg',
    use_eap: false,
    innovation: true,
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)']
  },
  {
    tag: 'optimism',
    chainId: '10',
    network: 'optimism',
    streaming: 'optimism',
    name: 'Optimism (OP Mainnet)',
    family: 'ethereum',
    platform: 'Smart Contract',
    nativeToken:'0x',
    currency: 'ETH',
    icon: 'currency/optimism.svg',
    use_eap: true,
    innovation: true,
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)']
  },
  {
    tag: 'opbnb',
    chainId: '204',
    network: 'opbnb',
    streaming: 'opbnb',
    name: 'opBNB',
    family: 'ethereum',
    platform: 'Smart Contract',
    nativeToken:'0x',
    currency: 'BNB',
    icon: 'currency/opbnb.svg',
    use_eap: true,
    innovation: true,
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)']
  },
  {
    tag: 'base',
    chainId: '8453',
    network: 'base',
    streaming: 'base',
    name: 'Base',
    family: 'ethereum',
    platform: 'Smart Contract',
    nativeToken:'0x',
    currency: 'ETH',
    icon: 'currency/base.svg',
    innovation: true,
    use_eap: false,
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)']
  },
  # {
  #   tag: 'etc',
  #   network: 'ethclassic',
  #   name: 'Ethereum Classic',
  #   family: 'ethereum',
  #   platform: 'Smart Contract',
  #   currency: 'ETC',
  #   icon: 'etc.svg',
  #   blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
  #   excludeNetworksPattern: [
  #     '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
  #     '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
  #   ],
  #   txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  # },
  # {
  #   tag: 'etc',
  #   network: 'ethclassic_reorg',
  #   name: 'Ethereum Classic no reorg',
  #   family: 'ethereum',
  #   platform: 'Smart Contract',
  #   currency: 'ETC',
  #   icon: 'etc.svg',
  #   blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
  #   excludeNetworksPattern: [
  #     '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
  #     '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
  #   ],
  #   txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  # },
  # {
  #   tag: 'ethpow',
  #   network: 'ethpow',
  #   name: 'Ethereum PoW',
  #   family: 'ethereum',
  #   platform: 'Smart Contract',
  #   currency: 'ETHW',
  #   icon: 'currency/ethpow.png',
  #   start: Date.parse('2022-09-15'),
  #   blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
  #   excludeNetworksPattern: [
  #     '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
  #     '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
  #   ],
  #   txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  # },
  {
    tag: 'arbitrum',
    chainId: '42161',
    network: 'arbitrum',
    streaming: 'arbitrum',
    name: 'Arbitrum Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    nativeToken:'0x',
    currency: 'ETH',
    innovation: true,
    use_eap: false,
    icon: 'currency/arbitrum.svg',
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  },
  {
    tag: 'zcash',
    network: 'zcash',
    name: 'ZCash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'ZEC',
    icon: 'zec.svg',
    blockchainAddressPattern: ['([\\W]|^)(t[1,3][\\da-zA-Z]{33})([\\W]|$)', '([\\W]|^)(d-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'bch',
    network: 'bitcash',
    name: 'Bitcoin Cash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'BCH',
    icon: 'bch.svg',
    blockchainAddressPattern: ['([\\W]|^)([q,p][\\da-zA-Z]{41})([\\W]|$)', '([\\W]|^)([m,d]-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']

  },
  # {
  #   tag: 'bsv',
  #   network: 'bitcoinsv',
  #   name: 'Bitcoin SV',
  #   family: 'bitcoin',
  #   platform: 'Bitcoin',
  #   currency: 'BSV',
  #   icon: 'bsv.svg',
  #   blockchainAddressPattern: ['([\\W]|^)([1,3][\\da-zA-Z]{33})([\\W]|$)', '([\\W]|^)([m,d]-[\\da-zA-Z]{32})([\\W]|$)'],
  #   excludeNetworksPattern: [
  #     '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
  #     '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
  #     '([\\W]|^)(T[\\w]{2})([\\W]|$)',
  #     '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
  #   ],
  #   txHashPattern: ['([\\W]|^)([\\da-fA-F]{64})([\\W]|$)']
  # },
  {
    tag: 'cardano2',
    network: 'cardano',
    name: 'Cardano',
    family: 'cardano',
    platform: 'Cardano',
    currency: 'ADA',
    icon: 'ada.svg',
    blockchainAddressPattern: ['([\\W]|^)((addr1)[2-49a-zA-Z][0-9a-zA-Z]{50,98})([\\W]|$)',
                               '([\\W]|^)(d-[\\da-zA-Z]{32})([\\W]|$)'],
    excludeNetworksPattern: ['([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)'],
    txHashPattern: ['([\\W]|^)([0-9A-Fa-f]{64})([\\W]|$)']
  },
  {
    tag: 'algorand',
    network: 'algorand',
    name: 'Algorand Mainnet',
    family: 'algorand',
    platform: 'Smart Contract',
    currency: 'ALGO',
    icon: 'currency/algo.png',
    blockchainAddressPattern: ['([\\W]|^)([0-9A-Z]{58})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9A-Z]{52})([\\W]|$)']
  },
  {
    tag: 'algorand_testnet',
    network: 'algorand_testnet',
    name: 'Algorand Testnet',
    family: 'algorand',
    platform: 'Testnet',
    currency: 'ALGO',
    icon: 'currency/algo.png',
    blockchainAddressPattern: ['([\\W]|^)([0-9A-Z]{58})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9A-Z]{52})([\\W]|$)']
  },
  {
    tag: 'algorand_betanet',
    network: 'algorand_betanet',
    name: 'Algorand Betanet',
    family: 'algorand',
    platform: 'Testnet',
    currency: 'ALGO',
    icon: 'currency/algo.png',
    blockchainAddressPattern: ['([\\W]|^)([0-9A-Z]{58})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9A-Z]{52})([\\W]|$)']
  },

  {
    tag: 'bnb',
    network: 'bsc',
    streaming: 'bsc',
    chainId: '56',
    name: 'BNB Smart Chain',
    family: 'ethereum',
    platform: 'Smart Contract',
    nativeToken:'0x',
    currency: 'BNB',
    icon: 'bnb.svg',
    use_eap: false,
    start: Date.parse('2020-08-29'),
    innovation: true,
    blockchainAddressPattern: ['([\\W]|^)(bnb[0-9a-z]{39})([\\W]|$)', '([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['(0x[0-9a-f]{64})']
  },
  {
    tag: 'conflux_hydra',
    network: 'conflux_hydra',
    name: 'Conflux Hydra',
    family: 'conflux',
    platform: 'Smart Contract',
    currency: 'CFX',
    icon: 'currency/conflux.png',
    blockchainAddressPattern: ['(\\W|^)((cfx:)[\\w\\d]{42})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  },
  {
    tag: 'conflux_oceanus',
    network: 'conflux_oceanus',
    name: 'Conflux Oceanus',
    family: 'conflux',
    platform: 'Testnet',
    currency: 'CFX',
    icon: 'currency/conflux.png',
    blockchainAddressPattern: ['(\\W|^)((cfx:)[\\w\\d]{42})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  },
  {
    tag: 'hedera',
    network: 'hedera',
    name: 'Hedera Hashgraph Mainnet',
    family: 'hedera',
    platform: 'Graph',
    currency: 'HBAR',
    icon: 'currency/hedera-hashgraph.svg',
    blockchainAddressPattern: ['([^\\.\\W]|^)((0+\\.){2}(\\d+))([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([\\da-fA-F]{96})([\\W]|$)']
  },
  {
    tag: 'eos',
    network: 'eos',
    name: 'EOS Mainnet',
    family: 'eos',
    platform: 'Smart Contract',
    currency: 'eosio.token',
    icon: 'eos.svg',
    blockchainAddressPattern: ['([\\W]|^)([\\w\\.]{2,32})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'tron',
    network: 'tron',
    name: 'TRON Mainnet',
    family: 'tron',
    platform: 'Smart Contract',
    currency: 'TRX',
    icon: 'trx.svg',
    streaming:'tron',
    blockchainAddressPattern: ['([\\W]|^)(T[\\w]{33})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'solana',
    network: 'solana',
    name: 'Solana Mainnet',
    family: 'solana',
    platform: 'Smart Contract',
    currency: 'SOL',
    icon: 'sol.svg',
    start: Date.parse('2021-01-01'),
    blockchainAddressPattern: ['([\\W]|^)([0-9a-zA-Z]{42,44})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)',
      '([\\W]|^)(cro[0-9a-z]{39})([\\W]|$)',
      '([\\W]|^)(T[\\w]{33})([\\W]|$)',
      '([\\W]|^)(bc1[\\da-zA-Z]{39,59})([\\W]|$)',
      '([\\W]|^)([3,1][\\da-zA-Z]{32,34})([\\W]|$)',
      '([\\W]|^)([0-9A-Z]{58})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{39})([\\W]|$)',
      '([\\W]|^)([q,p][\\da-zA-Z]{41})([\\W]|$)',
      '([\\W]|^)((addr1)[2-49a-zA-Z][0-9a-zA-Z]{50,98})([\\W]|$)',
      '(\\W|^)((cfx:)[\\w\\d]{42})([\\W]|$)',
      '([\\W]|^)([7,X][\\da-zA-Z]{33})([\\W]|$)',
      '([\\W]|^)([9,A,D][\\da-zA-Z]{33})([\\W]|$)',
      '([\\W]|^)(erd1[a-zA-HJ-NP-Z0-9]{40,70})([\\W]|$)',
      '([\\w]|^)(-?[0-9]\\d*(\\.\\d+)?:[0-9a-fA-F]{64})([\\W]|$)',
      '([\\W]|^)(f[0-9]{1,14})([\\W]|$)',
      '([\\W]|^)(0[x][0-9a-f]{16})([\\W]|$)',
      '([^\\.\\W]|^)((0+\\.){2}(\\d+))([\\W]|$)',
      '([\\W]|^)([L,M][\\da-zA-Z]{33})([\\W]|$)',
      '([\\W]|^)(ltc1[\\da-zA-Z]{39,59})([\\W]|$)',
      '([\\W]|^)(r[\\w]{32,33})([\\W]|$)',
      '([\\W]|^)(G[\\w]{55})([\\W]|$)',
      '([\\W]|^)((tz1|KT1|tz3|tz2)[\\w]{33})([\\W]|$)',
      '([\\W]|^)(T[\\w]{33})([\\W]|$)',
      '([\\W]|^)(t[1,3][\\da-zA-Z]{33})([\\W]|$)',
      '([\\W]|^)(d-[\\da-zA-Z]{32})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-zA-Z]{86,88})([\\W]|$)']
  },
  {
    tag: 'eth2',
    network: 'eth2',
    name: 'Beacon Chain Ethereum 2.0',
    family: 'ethereum2',
    platform: 'Beacon',
    currency: 'ETH',
    icon: 'eth.svg',
    start: Date.parse('2020-12-01'),
    blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  },
  {
    tag: 'filecoin',
    network: 'filecoin',
    name: 'Filecoin Mainnet',
    family: 'filecoin',
    platform: 'Utility',
    currency: 'FIL',
    icon: 'currency/fil.svg',
    blockchainAddressPattern: ['([\\W]|^)(f[0-9]{1,14})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)bafy[0-9a-zA-Z]+([\\W]|$)']
  },
  # {
  #   tag: 'matic',
  #   network: 'matic',
  #   streaming:'matic',
  #   use_eap: true,
  #   name: 'Matic (Polygon) Mainnet',
  #   # family: 'ethereum',
  #   family: 'cosmos',
  #   platform: 'Smart Contract',
  #   nativeToken:'0x',
  #   currency: 'MATIC',
  #   icon: 'matic.svg',
  #   start: Date.parse('2020-05-30'),
  #   blockchainAddressPattern: ['([\\W]|^)(0x[0-9a-fA-F]{40})([\\W]|$)'],
  #   excludeNetworksPattern: [
  #     '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
  #     '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
  #   ],
  #   txHashPattern: ['([\\W]|^)(0x[0-9a-f]{64})([\\W]|$)'] # //check hash
  # },
  {
    tag: 'elrond',
    network: 'elrond',
    name: 'The MultiversX (Elrond) Mainnet',
    family: 'elrond',
    platform: 'Smart Contract',
    currency: 'EGLD',
    icon: 'currency/egld-token-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)(erd1[a-zA-HJ-NP-Z0-9]{40,70})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([A-Fa-f0-9]{64})']
  },
  {
    tag: 'cosmoshub',
    network: 'cosmoshub',
    name: 'Cosmos Hub Network',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'ATOM',
    icon: 'currency/cosmos-atom-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)(cro[0-9a-z]{39})([\\W]|$)', '([\\W]|^)([0-9a-fA-F]{40})([\\W]|$)',
                               '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([A-Fa-f0-9]{64})([\\W]|$)']
  },
  {
    tag: 'crypto_mainnet',
    network: 'crypto_mainnet',
    name: 'Crypto.org Mainnet',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'CRO',
    icon: 'currency/cryptoorg-logo.png',
    blockchainAddressPattern: ['([\\W]|^)(cro[0-9a-z]{39})([\\W]|$)', '([\\W]|^)([0-9a-fA-F]{40})([\\W]|$)',
                               '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([A-Fa-f0-9]{64})([\\W]|$)']
  },
  {
    tag: 'heimdall',
    network: 'heimdall',
    name: 'Heimdall (Matic Verification Network)',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'MATIC',
    icon: 'currency/matic-logo.png',
    blockchainAddressPattern: ['([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)',
                               '([\\W]|^)([0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([A-Fa-f0-9]{64})([\\W]|$)']
  },
  {
    tag: 'terra',
    network: 'terra',
    name: 'Terra',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'LUNA',
    icon: 'currency/terra-luna-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)',
                               '([\\W]|^)([0-9a-fA-F]{40})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([A-Fa-f0-9]{64})([\\W]|$)']
  },
  {
    tag: 'flow',
    network: 'flow',
    name: 'Flow Mainnet',
    family: 'flow',
    platform: 'Smart Contract',
    currency: 'FLOW',
    icon: 'currency/flow.png',
    start: Date.parse('2020-09-23'),
    blockchainAddressPattern: ['([\\W]|^)(0[x][0-9a-f]{16})([\\W]|$)', '(^A\\.[0-9a-f]{16}\\.\\w+)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'stellar',
    network: 'stellar',
    name: 'Stellar Ledger',
    family: 'stellar',
    platform: 'Ripple',
    currency: 'XLM',
    icon: 'currency/stellar-xlm-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)(G[\\w]{55})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'ripple',
    network: 'ripple',
    name: 'Ripple XRP Ledger',
    family: 'ripple',
    platform: 'Ripple',
    currency: 'XRP',
    icon: 'currency/ripple-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)(r[\\dA-Za-z]{32,33})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['([\\W]|^)([0-9a-fA-F]{64})([\\W]|$)']
  },
  {
    tag: 'tezos',
    network: 'tezos',
    name: 'Tezos',
    family: 'tezos',
    platform: 'Tezos',
    currency: 'XTZ',
    icon: 'currency/tezos-xtz-logo.svg',
    blockchainAddressPattern: ['([\\W]|^)((tz1|KT1|tz3|tz2)[\\w]{33})([\\W]|$)'],
    excludeNetworksPattern: [
      '([\\W]|^)(bnb[0-9a-z]{2})([\\W]|$)',
      '([\\W]|^)(bnb[0-9a-z]{2)([\\W]|$)',
      '([\\W]|^)(T[\\w]{2})([\\W]|$)',
      '([\\W]|^)((cosmos1|terra1|tcro1|tcrocncl1)[a-zA-HJ-NP-Z0-9]{38,70})([\\W]|$)'
    ],
    txHashPattern: ['(o[\\w]{50})']
  }
].freeze

BLOCKCHAIN_BY_NAME = BLOCKCHAINS.index_by { |b| b[:network] }
