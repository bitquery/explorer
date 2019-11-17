Rails.application.routes.draw do


  namespace :ethereum do
    resources :address, :tx, :token
  end

  namespace :bitcoin do
    resources :address, :tx
  end

  root 'home#index'

end
