Rails.application.routes.draw do
  #get 'api/init'
  get 'api/new'
  post 'api/new'
  
  get 'api/search'
  
  match '/search', :to => 'api#search', :via => [:get, :post]
  
  resources :api

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
