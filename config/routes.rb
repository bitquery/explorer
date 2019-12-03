Rails.application.routes.draw do

  BLOCKCHAINS.select{|b| b[:family]=='bitcoin' }.each{|blockchain|
    get "#{blockchain[:path]}/tx/:id", to: "#{blockchain[:family]}/tx#show", defaults: {network: blockchain}
    get "#{blockchain[:path]}/address/:id", to: "#{blockchain[:family]}/address#show", defaults: {network: blockchain}
  }

  BLOCKCHAINS.select{|b| b[:family]=='ethereum' }.each{|blockchain|
    get "#{blockchain[:path]}/tx/:id", to: "#{blockchain[:family]}/tx#show", defaults: {network: blockchain}
    get "#{blockchain[:path]}/address/:id", to: "#{blockchain[:family]}/address#show", defaults: {network: blockchain}
    get "#{blockchain[:path]}/token/:id", to: "#{blockchain[:family]}/token#show", defaults: {network: blockchain}
  }

  match "search(/:query)", to: "search#show", via: [:get, :post], as: 'search'

  root 'home#index'

end
