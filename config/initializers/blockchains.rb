BLOCKCHAINS = [
  {
    tag: 'btc',
    network: 'bitcoin',
    name: 'Bitcoin Mainnet',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'BTC',
    icon: 'btc.svg'
  },
  {
    tag: 'ltc',
    network: 'litecoin',
    name: 'Litecoin',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'LTC',
    icon: 'ltc.svg'
  },
  {
    tag: 'doge',
    network: 'dogecoin',
    name: 'Dogecoin',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'DOGE',
    icon: 'doge.svg'
  },
  {
    tag: 'dash',
    network: 'dash',
    name: 'Dash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'DASH',
    icon: 'dash.svg'
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
    icon: 'eth.svg',
    innovation: true
  },
  {
    tag: 'etc',
    network: 'ethclassic',
    name: 'Ethereum Classic',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'ETC',
    icon: 'etc.svg'
  },
  {
    tag: 'etc',
    network: 'ethclassic_reorg',
    name: 'Ethereum Classic no reorg',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'ETC',
    icon: 'etc.svg'
  },
  {
    tag: 'ethpow',
    network: 'ethpow',
    name: 'Ethereum PoW',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'ETHW',
    icon: 'currency/ethpow.png',
    start: Date.parse('2022-09-15')
  },
  {
    tag: 'zcash',
    network: 'zcash',
    name: 'ZCash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'ZEC',
    icon: 'zec.svg'
  },
  {
    tag: 'bch',
    network: 'bitcash',
    name: 'Bitcoin Cash',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'BCH',
    icon: 'bch.svg'
  },
  {
    tag: 'bsv',
    network: 'bitcoinsv',
    name: 'Bitcoin SV',
    family: 'bitcoin',
    platform: 'Bitcoin',
    currency: 'BSV',
    icon: 'bsv.svg'
  },

  {
    tag: 'cardano2',
    network: 'cardano',
    name: 'Cardano',
    family: 'cardano',
    platform: 'Cardano',
    currency: 'ADA',
    icon: 'ada.svg'
  },

  {
    tag: 'algorand',
    network: 'algorand',
    name: 'Algorand Mainnet',
    family: 'algorand',
    platform: 'Smart Contract',
    currency: 'ALGO',
    icon: 'currency/algo.png'
  },
  {
    tag: 'algorand_testnet',
    network: 'algorand_testnet',
    name: 'Algorand Testnet',
    family: 'algorand',
    platform: 'Testnet',
    currency: 'ALGO',
    icon: 'currency/algo.png'
  },
  {
    tag: 'algorand_betanet',
    network: 'algorand_betanet',
    name: 'Algorand Betanet',
    family: 'algorand',
    platform: 'Testnet',
    currency: 'ALGO',
    icon: 'currency/algo.png'
  },
  {
    tag: 'binance',
    network: 'binance',
    name: 'Binance DEX',
    family: 'binance',
    platform: 'Cosmos',
    currency: 'BNB',
    icon: 'bnb.svg'
  },
  {
    tag: 'alfajores',
    network: 'celo_alfajores',
    name: 'Celo Alfajores Testnet',
    family: 'ethereum',
    platform: 'Testnet',
    currency: 'cGLD',
    icon: 'currency/celo.png',
    start: Date.parse('2020-04-10')
  },
  {
    tag: 'bsc_testnet',
    network: 'bsc_testnet',
    name: 'Binance Smart Chain Testnet',
    family: 'ethereum',
    platform: 'Testnet',
    currency: 'BNB',
    icon: 'bnb.svg',
    start: Date.parse('2020-04-20')
  },
  {
    tag: 'bsc',
    network: 'bsc',
    streaming: 'bsc',
    chainId: '56',
    name: 'Binance Smart Chain Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'BNB',
    icon: 'bnb.svg',
    start: Date.parse('2020-08-29'),
    innovation: true
  },
  {
    tag: 'goerli',
    network: 'goerli',
    name: 'Goerli Ethereum Testnet',
    family: 'ethereum',
    platform: 'Testnet',
    currency: 'GTH',
    icon: 'eth.svg',
    start: Date.parse('2019-01-30')
  },
  {
    tag: 'baklava',
    network: 'celo_baklava',
    name: 'Celo Baklava Testnet',
    family: 'ethereum',
    platform: 'Testnet',
    currency: 'cGLD',
    icon: 'currency/celo.png',
    start: Date.parse('2020-04-07')
  },
  {
    tag: 'celo',
    network: 'celo_mainnet',
    name: 'Celo Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'cGLD',
    icon: 'currency/celo.png',
    start: Date.parse('2020-04-22')
  },
  {
    tag: 'conflux_hydra',
    network: 'conflux_hydra',
    name: 'Conflux Hydra',
    family: 'conflux',
    platform: 'Smart Contract',
    currency: 'CFX',
    icon: 'currency/conflux.png'
  },
  {
    tag: 'conflux_oceanus',
    network: 'conflux_oceanus',
    name: 'Conflux Oceanus',
    family: 'conflux',
    platform: 'Testnet',
    currency: 'CFX',
    icon: 'currency/conflux.png'
  },
  {
    tag: 'hedera',
    network: 'hedera',
    name: 'Hedera Hashgraph Mainnet',
    family: 'hedera',
    platform: 'Graph',
    currency: 'HBAR',
    icon: 'currency/hedera-hashgraph.svg'
  },
  {
    tag: 'eos',
    network: 'eos',
    name: 'EOS Mainnet',
    family: 'eos',
    platform: 'Smart Contract',
    currency: 'eosio.token',
    icon: 'eos.svg'
  },
  {
    tag: 'tron',
    network: 'tron',
    name: 'TRON Mainnet',
    family: 'tron',
    platform: 'Smart Contract',
    currency: 'TRX',
    icon: 'trx.svg'
  },
  {
    tag: 'solana',
    network: 'solana',
    name: 'Solana Mainnet',
    family: 'solana',
    platform: 'Smart Contract',
    currency: 'SOL',
    icon: 'sol.svg',
    start: Date.parse('2021-01-01')
  },
  {
    tag: 'medalla',
    network: 'medalla',
    name: 'Medalla Eth 2.0 Testnet',
    family: 'ethereum2',
    platform: 'Testnet',
    currency: 'ETH',
    icon: 'eth.svg',
    start: Date.parse('2020-08-03')
  },
  {
    tag: 'eth2',
    network: 'eth2',
    name: 'Beacon Chain Ethereum 2.0',
    family: 'ethereum2',
    platform: 'Beacon',
    currency: 'ETH',
    icon: 'eth.svg',
    start: Date.parse('2020-12-01')
  },
  {
    tag: 'filecoin',
    network: 'filecoin',
    name: 'Filecoin Mainnet',
    family: 'filecoin',
    platform: 'Utility',
    currency: 'FIL',
    icon: 'currency/fil.svg'
  },
  {
    tag: 'matic',
    network: 'matic',
    name: 'Matic (Polygon) Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'MATIC',
    icon: 'matic.svg',
    start: Date.parse('2020-05-30')
  },
  {
    tag: 'velas',
    network: 'velas',
    name: 'Velas Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'VLX',
    icon: 'currency/velas.png',
    start: Date.parse('2021-04-19')
  },
  {
    tag: 'velas_testnet',
    network: 'velas_testnet',
    name: 'Velas Testnet',
    family: 'ethereum',
    platform: 'Testnet',
    currency: 'VLX',
    icon: 'currency/velas.png',
    start: Date.parse('2021-04-12')
  },
  {
    tag: 'klaytn',
    network: 'klaytn',
    name: 'Klaytn Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'KLAY',
    icon: 'currency/klaytn.png',
    start: Date.parse('2019-06-25')
  },
  {
    tag: 'elrond',
    network: 'elrond',
    name: 'The MultiversX (Elrond) Mainnet',
    family: 'elrond',
    platform: 'Smart Contract',
    currency: 'EGLD',
    icon: 'currency/egld-token-logo.svg'
  },
  {
    tag: 'avalanche',
    network: 'avalanche',
    name: 'Avalanche  C-chain',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'AVAX',
    icon: 'currency/avalanche.png',
    start: Date.parse('2020-09-23')
  },
  {
    tag: 'fantom',
    network: 'fantom',
    name: 'Fantom Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'FTM',
    icon: 'currency/fantom.png',
    start: Date.parse('2019-12-27')
  },
  {
    tag: 'moonbeam',
    network: 'moonbeam',
    name: 'Moonbeam Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'GLMR',
    icon: 'currency/moonbeam.png',
    start: Date.parse('2021-12-18')
  },
  {
    tag: 'cronos',
    network: 'cronos',
    name: 'Cronos Mainnet',
    family: 'ethereum',
    platform: 'Smart Contract',
    currency: 'CRO',
    icon: 'currency/cronos.png',
  },

  {
    tag: 'cosmoshub',
    network: 'cosmoshub',
    name: 'Cosmos Hub Network',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'ATOM',
    icon: 'currency/cosmos-atom-logo.svg'
  },

  {
    tag: 'crypto_mainnet',
    network: 'crypto_mainnet',
    name: 'Crypto.org Mainnet',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'CRO',
    icon: 'currency/cryptoorg-logo.png'
  },
  {
    tag: 'crypto_testnet',
    network: 'crypto_testnet',
    name: 'Crypto.org Croeseid Testnet',
    family: 'cosmos',
    platform: 'Testnet',
    currency: 'TCRO',
    icon: 'currency/cryptoorg-logo.png'
  },
  {
    tag: 'heimdall',
    network: 'heimdall',
    name: 'Heimdall (Matic Verification Network)',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'MATIC',
    icon: 'currency/matic-logo.png'
  },
  {
    tag: 'terra',
    network: 'terra',
    name: 'Terra',
    family: 'cosmos',
    platform: 'Cosmos',
    currency: 'LUNA',
    icon: 'currency/terra-luna-logo.svg'
  },
  {
    tag: 'flow',
    network: 'flow',
    name: 'Flow Mainnet',
    family: 'flow',
    platform: 'Smart Contract',
    currency: 'FLOW',
    icon: 'currency/flow.png',
    start: Date.parse('2020-09-23')
  },
  {
    tag: 'stellar',
    network: 'stellar',
    name: 'Stellar Ledger',
    family: 'stellar',
    platform: 'Ripple',
    currency: 'XLM',
    icon: 'currency/stellar-xlm-logo.svg'
  },
  {
    tag: 'ripple',
    network: 'ripple',
    name: 'Ripple XRP Ledger',
    family: 'ripple',
    platform: 'Ripple',
    currency: 'XRP',
    icon: 'currency/ripple-logo.svg'
  },
  {
    tag: 'tezos',
    network: 'tezos',
    name: 'Tezos',
    family: 'tezos',
    platform: 'Tezos',
    currency: 'XTZ',
    icon: 'currency/tezos-xtz-logo.svg'
  },
  {
    tag: 'everscale',
    network: 'everscale',
    name: 'Everscale',
    family: 'everscale',
    platform: 'Smart Contract',
    currency: 'EVER',
    icon: 'currency/everscale-logo.png'
  },
  {
    tag: 'arbitrum',
    chainId: '42161',
    network: 'arbitrum',
    streaming: 'arbitrum',
    name: 'Ethereum Mainnet',
    family: 'ethereum_streaming',
    platform: 'Smart Contract',
    currency: 'ETH',
    icon: 'currency/arbitrum.svg'
  },
].freeze

BLOCKCHAIN_BY_NAME = BLOCKCHAINS.index_by { |b| b[:network] }
