Rails.application.routes.draw do

  scope "(:locale)", constraints: lambda { |request| !request.params[:locale] || I18n.locale_available?(request.params[:locale].to_sym) } do

    BLOCKCHAINS.select{|b| b[:family]=='ethereum'}.each{|blockchain|
      get ":blockchain/address/:id", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:id", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/token/:id", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='binance' }.each{|blockchain|
      get ":blockchain/address/:id", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:id", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/token/:id", controller: "#{blockchain[:family]}/token", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='bitcoin' }.each{|blockchain|
      get ":blockchain/address/:id", controller: "#{blockchain[:family]}/address", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
      get ":blockchain/tx/:id", controller: "#{blockchain[:family]}/tx", action: 'show', constraints: { blockchain: blockchain[:path] }, defaults: {network: blockchain}
    }


    get "covid", controller: 'covid/dashboard', action: 'index', as: 'covid_index'
    get "covid/country/:code/:name", controller: 'covid/country', action: 'index'

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

    root 'home#index'
    get '*path' => "utility#errors"
  end

end
