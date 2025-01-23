ADS = {
  top: {
    ads: [
    ]
  },
  bottom: {
    ads: [
    # {
    #   image: 'ads/7bit/728x90_elvis-frog.gif',
    #   url: 'https://7bit.partners/pf03dd034'
    # },
    # {
    #   image: 'ads/7bit/728x90_welcome_5Btc-250.gif',
    #   url: 'https://7bit.partners/p86936f5b'
    # }
    ]
  },
  tab: {
    ads: [
      {
        text: 'Looking for Investigators?',
        url: 'https://bitquery.io/products/crypto-investigation-services?utm_source=explorer&utm_medium=website&utm_content=navigation_button',
        bgcolor: '#0570f2',
        path_matches: '/graph.*|\/tx.*|\/address.*'
      },
      {
        ad_name: 'dexrabbit',
        text: 'Buy {token_symbol}',
        urls: 'https://dexrabbit.com/{blockchain_slug}/token/{token_address}',
        bgcolor: '#e95e42',
        path_matches: '^/(ethereum|tron|matic|bsc|arbitrum)/token/[^/]+$'
      },
      {
        ad_name: 'exchanges_ref',
        text: 'Buy {token_symbol}',
        urls: [
          'https://www.bydfi.com/en/register?ru=Ee9cjN',
          'https://www.kucoin.com/r/rf/QBSK241Z',
          'https://bingx.pro/invite/OXN3NG',
          'https://accounts.binance.com/register?ref=820827844',
          'https://partner.bybit.com/b/68182',
          'https://go.primexbt.direct/visit/?bta=35291&brand=primexbt'
        ],
        bgcolor: '#b86614'
      }
    ]
  },
  widgets: {
    # ad: {
    #   text: 'Buy this ad',
    #   url: 'https://bitquery.io/forms/ads'
    # },
  },
  fixed: {
    # ad: {
    #  title: 'Swap at the best rates!',
    #  title_color: '#000000',
    #  text: 'Gasless execution and MEV protection on 1inch - #1 DEX aggregator.',
    #  text_color: '#000000',
    #  button_text: 'Swap now!',
    #  button_class: 'btn-primary',
    # button_bg: '#2F8AF5',
    # button_color: '#000',
    #  image: '1inch.jpg',
    #  url: 'https://jn3rg.app.link/Bitquery_1inch_FixedBanner',
    #  width: '28rem'
    # },
    # platform: {
    #   smart_contract: {
    #     ad: {
    #       text: '13',
    #       url: '21'
    #     }
    #   }
    # }
  }
}.freeze
