Rails.application.routes.draw do
  root 'home#show'

  get '/authentication/callback' => 'authentication#callback'
  get '/authentication/failure' => 'authentication#failure'

  get '/dashboard' => 'dashboard#show'
end
