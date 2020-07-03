

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
        network: 'ethereum',
        name: 'Ethereum Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'ETH',
        icon: 'eth.svg'
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
        tag: 'cardano',
        network: 'cardano',
        name: 'Cardano',
        family: 'bitcoin',
        platform: 'Bitcoin',
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
        icon: 'currency/algo.png',

    },

    {
        tag: 'algorand_testnet',
        network: 'algorand_testnet',
        name: 'Algorand Testnet',
        family: 'algorand',
        platform: 'Testnet',
        currency: 'ALGO',
        icon: 'currency/algo.png',

    },

    {
        tag: 'algorand_betanet',
        network: 'algorand_betanet',
        name: 'Algorand Betanet',
        family: 'algorand',
        platform: 'Testnet',
        currency: 'ALGO',
        icon: 'currency/algo.png',

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
        network: 'celo_rc1',
        name: 'Celo Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'cGLD',
        icon: 'currency/celo.png',
        start: Date.parse('2020-04-22')
    },

    {
        tag: 'conflux',
        network: 'celo_rc1',
        name: 'Celo Mainnet',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'cGLD',
        icon: 'currency/celo.png',
        start: Date.parse('2020-04-22')
    },




]

BLOCKCHAIN_BY_NAME = Hash[BLOCKCHAINS.map{|b| [b[:network], b]}]
