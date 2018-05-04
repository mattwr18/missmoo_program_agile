Rails.application.routes.draw do
  devise_for :users
  root :to => 'homepage#index'

  resources :sales
  resources :purchases
  resources :clients
  resources :products
  get '/profit' => 'profit#index'
end
