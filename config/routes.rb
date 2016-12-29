Rails.application.routes.draw do
  get 'api/search'
  #get 'api/init'
  get 'api/new'
  
  post 'api/search'
  post 'api/new'
  
  resources :api

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
