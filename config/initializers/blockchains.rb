

BLOCKCHAINS = [

     {
        tag: 'eth',
        network: 'ethereum',
        name: 'Ethereum Mainnet',
        path: 'ethereum',
        family: 'ethereum',
        currency: 'ETH',
        icon: 'eth.svg'
    },

     {
         tag: 'etc',
         network: 'ethclassic',
         name: 'Ethereum Classic',
         path: 'ethclassic',
         family: 'ethereum',
         currency: 'ETC',
         icon: 'etc.svg'

     },

     #{
     #    tag: 'alfajores',
     #    network: 'alfajores',
     #    name: 'Celo Alfajores Testnet',
     #    path: 'alfajores',
     #    family: 'ethereum',
     #    currency: 'cGLD',
     #    icon: 'generic.svg'

     #},

     {
         tag: 'binance',
         network: 'binance',
         name: 'Binance DEX',
         path: 'binance',
         family: 'cosmos',
         currency: 'BNB',
         icon: 'bnb.svg'

     },

    #{
    #    tag: 'tron',
    #    network: 'tron',
    #    name: 'Tron',
    #    path: 'tron',
    #    family: 'tron'
    #
    #},

    #{
    #    tag: 'btc',
    #    network: 'bitcoin',
    #    name: 'Bitcoin',
    #    path: 'bitcoin',
    #    family: 'bitcoin',
    #    currency: 'BTC'
    #},
    #
    #{
    #    tag: 'bch',
    #    network: 'bitcash',
    #    name: 'Bitcoin Cash',
    #    path: 'bitcash',
    #    family: 'bitcoin'
    #},

    #{
    #    tag: 'ltc',
    #    network: 'litecoin',
    #    name: 'Litecoin',
    #    path: 'litecoin',
    #    family: 'bitcoin'
    #
    #},

    #{
    #    tag: 'dash',
    #    network: 'dash',
    #    name: 'Dash',
    #    path: 'dash',
    #    family: 'bitcoin'
    #
    #},

    #{
    #    tag: 'doge',
    #    network: 'doge',
    #    name: 'Dogecoin',
    #    path: 'doge',
    #    family: 'bitcoin'
    #
    #},

    #{
    #    tag: 'cardano',
    #    network: 'cardano',
    #    name: 'Cardano',
    #    path: 'cardano',
    #    family: 'bitcoin'
    #
    #},

    #{
    #    tag: 'eos',
    #    network: 'eos',
    #    name: 'EOS',
    #    path: 'eos',
    #    family: 'eos'
    #
    #},
     #

    #{
    #    tag: 'stellar',
    #    network: 'stellar',
    #    name: 'Stellar',
    #    path: 'stellar',
    #    family: 'stellar'
    #
    #},

    #{
    #    tag: 'ripple',
    #    network: 'ripple',
    #    name: 'Ripple',
    #    path: 'ripple',
    #    family: 'ripple'
    #},

]

BLOCKCHAIN_BY_NAME = Hash[BLOCKCHAINS.map{|b| [b[:network], b]}]
