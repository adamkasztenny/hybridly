Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  root 'home#show'

  get '/authentication/callback' => 'authentication#callback'
  get '/authentication/failure' => 'authentication#failure'

  get '/dashboard' => 'dashboard#show'
  get '/insights' => 'insights#show'

  resource :reservations
  get '/reservations/:date' => 'reservations#show_for_date'
  get '/reservations/:verification_code/verify' => 'reservations#verify'

  resource :reservation_policies
  resource :workspaces
end
