Rails.application.routes.draw do
  root :to => 'homepage#index'

  resources :sales
  get '/purchases' => 'purchases#index'
  get '/profit' => 'profit#index'
end
