Rails.application.routes.draw do


  scope "(:locale)", constraints: lambda { |request| !request.params[:locale] || I18n.locale_available?(request.params[:locale].to_sym) } do

    BLOCKCHAINS.select{|b| b[:family]=='ethereum'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/smart_contract/:address/graph", controller: "#{blockchain[:family]}/smart_contract", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/token/:address/graph", controller: "#{blockchain[:family]}/token", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/dex_protocol/:protocol_name/:action", controller: "#{blockchain[:family]}/dex_protocol", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/dex_protocol/:protocol_name", controller: "#{blockchain[:family]}/dex_protocol", action: 'statistics', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/dex/:exchange/:action", controller: "#{blockchain[:family]}/dex", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/dex/:exchange", controller: "#{blockchain[:family]}/dex", action: 'statistics', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}


      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tokenpair/:token1/:token2", controller: "#{blockchain[:family]}/token_pair", action: 'trading_view', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tokenpair/:token1/:token2/trading_view", controller: "#{blockchain[:family]}/token_pair", action: 'trading_view', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tokenpair/:token1/:token2/last_trades", controller: "#{blockchain[:family]}/token_pair", action: 'last_trades', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='ethereum2'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/validator/:index/:action", controller: "#{blockchain[:family]}/validator", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/validator/:index", controller: "#{blockchain[:family]}/validator", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}


    }


    BLOCKCHAINS.select{|b| b[:family]=='tron'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/smart_contract/:address/graph", controller: "#{blockchain[:family]}/smart_contract", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/trc20token/:address/:action", controller: "#{blockchain[:family]}/trc20token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/trc20token/:address", controller: "#{blockchain[:family]}/trc20token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/trc10token/:address/:action", controller: "#{blockchain[:family]}/trc10token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/trc10token/:address", controller: "#{blockchain[:family]}/trc10token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/dex_protocol/:protocol_name/:action", controller: "#{blockchain[:family]}/dex_protocol", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/dex_protocol/:protocol_name", controller: "#{blockchain[:family]}/dex_protocol", action: 'statistics', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/dex/:exchange/:action", controller: "#{blockchain[:family]}/dex", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/dex/:exchange", controller: "#{blockchain[:family]}/dex", action: 'statistics', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}


      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='eos'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}

      get ":blockchain/smart_contract/:address/graph", controller: "#{blockchain[:family]}/smart_contract", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}

      get ":blockchain/token/:address/graph", controller: "#{blockchain[:family]}/token", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network], address: /[^\/]+/ }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='conflux'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}


      get ":blockchain/smart_contract/:address/graph", controller: "#{blockchain[:family]}/smart_contract", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/token/:address/graph", controller: "#{blockchain[:family]}/token", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:hash/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:hash", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='diem'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/token/:address/graph", controller: "#{blockchain[:family]}/token", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family] == 'hedera'}.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'transactions'

          get ":blockchain/:action", controller: "#{blockchain[:family]}/network"

          get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show'
          get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx"

          # route with dot parameter is not available by default.
          get ":blockchain/topics/:topic_id", controller: "#{blockchain[:family]}/topics", action: 'show', constraints: { topic_id: /[^\/]+/ }
          get ":blockchain/topics/:topic_id/:action", controller: "#{blockchain[:family]}/topics", constraints: { topic_id: /[^\/]+/ }

          get ":blockchain/accounts/:account_id", controller: "#{blockchain[:family]}/accounts", action: 'show', constraints: { account_id: /[^\/]+/ }
          get ":blockchain/accounts/:account_id/:action", controller: "#{blockchain[:family]}/accounts", constraints: { account_id: /[^\/]+/ }

          get ":blockchain/nodes/:node_account", controller: "#{blockchain[:family]}/nodes", action: 'show', constraints: { node_account: /[^\/]+/ }
          get ":blockchain/payers/:payer_account", controller: "#{blockchain[:family]}/payers", action: 'show', constraints: { payer_account: /[^\/]+/ }

          get ":blockchain/contracts/:contract_id", controller: "#{blockchain[:family]}/contracts", action: 'show', constraints: { contract_id: /[^\/]+/ }

          get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index'
        end
      end
    end

    BLOCKCHAINS.select{|b| b[:family]=='binance' }.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/order/:order/:action", controller: "#{blockchain[:family]}/order", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/order/:order", controller: "#{blockchain[:family]}/order", action: 'statuses', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/token/:symbol/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:symbol", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='bitcoin' }.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='cardano' }.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='filecoin' }.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/message/:hash", controller: "#{blockchain[:family]}/message", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/message/:hash/transfers", controller: "#{blockchain[:family]}/message", action: 'transfers', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/height/:height/:action", controller: "#{blockchain[:family]}/height", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/height/:height", controller: "#{blockchain[:family]}/height", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='algorand'}.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}


      get ":blockchain/smart_contract/:address/graph", controller: "#{blockchain[:family]}/smart_contract", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/token/:id/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/token/:id", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family] == 'solana'}.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks'

          get ":blockchain/:action", controller: "#{blockchain[:family]}/network"

          get ":blockchain/block/:block_id", controller: "#{blockchain[:family]}/block", action: 'show'
          get ":blockchain/block/:block_id/:action", controller: "#{blockchain[:family]}/block"

          get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show'
          get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx"

          get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show'
          get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address"

          get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index'
        end
      end
    end

    BLOCKCHAINS.select { |b| b[:family] == 'elrond' }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'shards'

          get ":blockchain/:action", controller: "#{blockchain[:family]}/network"

          get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show'
          get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx"

          get ":blockchain/block/:hash", controller: "#{blockchain[:family]}/block", action: 'show'
          get ":blockchain/block/:hash/:action", controller: "#{blockchain[:family]}/block"

          get ":blockchain/miniblocks/:hash", controller: "#{blockchain[:family]}/miniblocks", action: 'show'
          get ":blockchain/miniblocks/:hash/:action", controller: "#{blockchain[:family]}/miniblocks"

          get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show'
          get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address"

          get ":blockchain/validators/:hash", controller: "#{blockchain[:family]}/validators", action: 'show'
          get ":blockchain/validators/:hash/:action", controller: "#{blockchain[:family]}/validators"

          get ":blockchain/shards/:id", controller: "#{blockchain[:family]}/shards", action: 'show'
          get ":blockchain/shards/:id/:action", controller: "#{blockchain[:family]}/shards"

          get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index'
        end
      end
    end



    BLOCKCHAINS.select{|b| b[:family]=='cosmos' }.each{|blockchain|

      get ":blockchain/:action", controller: "#{blockchain[:family]}/network", constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/address/:address/graph", controller: "#{blockchain[:family]}/address", action: 'money_flow',constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/height/:height", controller: "#{blockchain[:family]}/height", action: 'blocks', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

    }
    BLOCKCHAINS.select { |b| b[:family] == 'flow' }.each do |blockchain|
      constraints(blockchain: blockchain[:network]) do
        defaults network: blockchain do
          get ":blockchain", controller: "#{blockchain[:family]}/network", action: 'blocks'

          get ":blockchain/:action", controller: "#{blockchain[:family]}/network"

          get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show'
          get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block"

          get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show'
          get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx"

          get ":blockchain/collections/:hash", controller: "#{blockchain[:family]}/collections", action: 'show'
          get ":blockchain/collections/:hash/:action", controller: "#{blockchain[:family]}/collections"

          get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show'
          get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address"

          get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index'
        end
      end
    end

    get "covid", controller: 'covid/covid_dashboard', action: 'index', as: 'covid_index'
    get "covid/:action", controller: 'covid/covid_dashboard'
    get "covid/country/:code/:name", controller: 'covid/covid_country', action: 'index', as: 'covid_country'
    get "covid/country/:code/:name/:action", controller: 'covid/covid_country'
    get "covid/continent/:code", controller: 'covid/covid_continent', action: 'index', as: 'covid_continent'
    get "covid/continent/:code/:action", controller: 'covid/covid_continent'
    get "covid_sitemap.xml", controller: 'covid/sitemap', action: 'index', as: 'covid_sitemap'


    match "search(/:query)", to: "search#show", via: [:get, :post], as: 'search', constraints: { query: /[^\/]+/ }

    post 'proxy_graphql', to: "proxy_graphql#index", defaults: { format: :json }
    get 'proxy_dbcode/:dashbord_url', to: "proxy_dbcode#index", defaults: { format: :json }

    get "platform/:action", controller: "home"
    get "graphql(/:param)" => "utility#graphql"
    get "graphql/reset(/:token)" => "utility#graphql"
    root 'home#index'


    # error pages
    #%w( 404 422 500 503 400 401 403 ).each do |code|
    ##  match "/#{code}", :to => :error, controller: "utility", id: code, via: :all
    #  match "/#{code}", :to => "utility#errors", via: :all
    #end
    get 'sitemap.xml' => "sitemaps#index"
    get 'robots.txt' => "sitemaps#robots"
    get '*path' => "utility#errors"
  end

end
