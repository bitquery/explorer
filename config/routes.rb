Rails.application.routes.draw do

  namespace :ethereum do
    get 'event/show'
  end
  namespace :ethereum do
    get 'method/show'
  end
  namespace :ethereum do
    get 'block/show'
  end
  scope "(:locale)", constraints: lambda { |request| !request.params[:locale] || I18n.locale_available?(request.params[:locale].to_sym) } do

    BLOCKCHAINS.select{|b| b[:family]=='ethereum'}.each{|blockchain|

      get ":blockchain/address/:address/:action", controller: "#{blockchain[:family]}/address", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/smart_contract/:address/:action", controller: "#{blockchain[:family]}/smart_contract", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/smart_contract/:address", controller: "#{blockchain[:family]}/smart_contract", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/token/:address/:action", controller: "#{blockchain[:family]}/token", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/tx/:hash/:action", controller: "#{blockchain[:family]}/tx", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/txs/:action", controller: "#{blockchain[:family]}/tx_list", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/block/:block/:action", controller: "#{blockchain[:family]}/block", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/block/:block", controller: "#{blockchain[:family]}/block", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/method/:signature/:action", controller: "#{blockchain[:family]}/method", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/method/:signature", controller: "#{blockchain[:family]}/method", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

      get ":blockchain/event/:signature/:action", controller: "#{blockchain[:family]}/event", constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/event/:signature", controller: "#{blockchain[:family]}/event", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}

    }

    BLOCKCHAINS.select{|b| b[:family]=='binance' }.each{|blockchain|
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:hash", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/token/:address", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='bitcoin' }.each{|blockchain|
      get ":blockchain/address/:address", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:address", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
    }


    get "covid", controller: 'covid/dashboard', action: 'index', as: 'covid_index'
    get "covid/country/:code/:name", controller: 'covid/country', action: 'index', as: 'covid_country'
    get "covid/continent/:code", controller: 'covid/continent', action: 'index', as: 'covid_continent'

    #get ":blockchain/address/:id", controller: 'ethereum/address', action: 'show', constraints: { blockchain: /ethereum/ },
    #    defaults: {network: BLOCKCHAINS[0]}

    #get ":blockchain/address/:id", controller: 'ethereum/address', action: 'show', constraints: { blockchain: /ethclassic/ },
    #    defaults: {network: BLOCKCHAINS[1]}


    match "search(/:query)", to: "search#show", via: [:get, :post], as: 'search'

    # error pages
    #%w( 404 422 500 503 400 401 403 ).each do |code|
    ##  match "/#{code}", :to => :error, controller: "utility", id: code, via: :all
    #  match "/#{code}", :to => "utility#errors", via: :all
    #end

    get 'sitemap.xml' => "sitemaps#index"
    get 'robots.txt' => "sitemaps#robots"
    root 'home#index'
    get '*path' => "utility#errors"
  end

end
