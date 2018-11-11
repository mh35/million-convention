Rails.application.routes.draw do
  root 'top#index'
  get '/login', to: 'login#index'
  get '/login/callback', to: 'login#callback'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
