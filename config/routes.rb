Rails.application.routes.draw do
  get '/user', to: 'users#show'
  get '/help', to: 'pages#help'
  root to: 'pages#home'
end
