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

      get ":blockchain/sitemap/index.xml", controller: "#{blockchain[:family]}/sitemap", action: 'index', constraints: { blockchain: blockchain[:network] }, defaults: {network: blockchain}

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

    BLOCKCHAINS.select{|b| b[:family]=='libra'}.each{|blockchain|

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

    BLOCKCHAINS.select{|b| b[:family]=='filecoin' }.each{|blockchain|

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


    get "covid", controller: 'covid/covid_dashboard', action: 'index', as: 'covid_index'
    get "covid/:action", controller: 'covid/covid_dashboard'
    get "covid/country/:code/:name", controller: 'covid/covid_country', action: 'index', as: 'covid_country'
    get "covid/country/:code/:name/:action", controller: 'covid/covid_country'
    get "covid/continent/:code", controller: 'covid/covid_continent', action: 'index', as: 'covid_continent'
    get "covid/continent/:code/:action", controller: 'covid/covid_continent'
    get "covid_sitemap.xml", controller: 'covid/sitemap', action: 'index', as: 'covid_sitemap'


    match "search(/:query)", to: "search#show", via: [:get, :post], as: 'search', constraints: { query: /[^\/]+/ }

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
