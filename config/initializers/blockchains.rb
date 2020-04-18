

BLOCKCHAINS = [

     {
        tag: 'eth',
        network: 'ethereum',
        name: 'Ethereum Mainnet',
        path: 'ethereum',
        family: 'ethereum',
        platform: 'Smart Contract',
        currency: 'ETH',
        icon: 'eth.svg'
    },

     {
         tag: 'etc',
         network: 'ethclassic',
         name: 'Ethereum Classic',
         path: 'ethclassic',
         family: 'ethereum',
         platform: 'Smart Contract',
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
         family: 'binance',
         platform: 'Cosmos',
         currency: 'BNB',
         icon: 'bnb.svg'

     },

      {
          tag: 'btc',
          network: 'bitcoin',
          name: 'Bitcoin',
          path: 'bitcoin',
          family: 'bitcoin',
          platform: 'Bitcoin',
          currency: 'BTC',
          icon: 'btc.svg'
      },

     {
         tag: 'ltc',
         network: 'litecoin',
         name: 'Litecoin',
         path: 'litecoin',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'LTC',
         icon: 'ltc.svg'
     },

     {
         tag: 'bch',
         network: 'bitcash',
         name: 'Bitcoin Cash',
         path: 'bitcash',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'BCH',
         icon: 'bch.svg'
     },

     {
         tag: 'bsv',
         network: 'bitcoinsv',
         name: 'Bitcoin SV',
         path: 'bitcoinsv',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'BSV',
         icon: 'bsv.svg'
     },

     {
         tag: 'dash',
         network: 'dash',
         name: 'Dash',
         path: 'dash',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'DASH',
         icon: 'dash.svg'
     },

     {
         tag: 'doge',
         network: 'dogecoin',
         name: 'Dogecoin',
         path: 'doge',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'DOGE',
         icon: 'doge.svg'
     },

     {
         tag: 'cardano',
         network: 'cardano',
         name: 'Cardano',
         path: 'cardano',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'ADA',
         icon: 'ada.svg'
     },

     {
         tag: 'zcash',
         network: 'zcash',
         name: 'ZCash',
         path: 'zcash',
         family: 'bitcoin',
         platform: 'Bitcoin',
         currency: 'ZEC',
         icon: 'zec.svg'
     },

]

BLOCKCHAIN_BY_NAME = Hash[BLOCKCHAINS.map{|b| [b[:network], b]}]
