Rails.application.routes.draw do

  scope "(:locale)", constraints: lambda { |request| !request.params[:locale] || I18n.locale_available?(request.params[:locale].to_sym) } do
    BLOCKCHAINS.select{|b| b[:family]=='bitcoin' }.each{|blockchain|
      get "#{blockchain[:path]}/tx/:id", to: "#{blockchain[:family]}/tx#show", defaults: {network: blockchain}
      get "#{blockchain[:path]}/address/:id", to: "#{blockchain[:family]}/address#show", defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='ethereum' }.each{|blockchain|
      get "#{blockchain[:path]}/tx/:id", to: "#{blockchain[:family]}/tx#show", defaults: {network: blockchain}
      get "#{blockchain[:path]}/address/:id", to: "#{blockchain[:family]}/address#show", defaults: {network: blockchain}
      get "#{blockchain[:path]}/token/:id", to: "#{blockchain[:family]}/token#show", defaults: {network: blockchain}
    }

    BLOCKCHAINS.select{|b| b[:family]=='binance' }.each{|blockchain|
      get "#{blockchain[:path]}/tx/:id", to: "#{blockchain[:family]}/tx#show", defaults: {network: blockchain}
      get "#{blockchain[:path]}/address/:id", to: "#{blockchain[:family]}/address#show", defaults: {network: blockchain}
      get "#{blockchain[:path]}/token/:id", to: "#{blockchain[:family]}/token#show", defaults: {network: blockchain}
    }

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
