Rails.application.routes.draw do
  root 'home#show'

  get '/auth/callback' => 'auth#callback'
  get '/auth/failure' => 'auth#failure'

  get '/dashboard' => 'dashboard#show'
end
