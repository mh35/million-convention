Rails.application.routes.draw do

  root 'top#index'
  get '/login', to: 'login#index'
  get '/login/callback', to: 'login#callback'
  get '/logout', to: 'login#logout'
  get '/privacy', to: 'privacy#index'
  get '/terms', to: 'terms#index'
  resources :idols, except: [:index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
