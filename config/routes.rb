Rails.application.routes.draw do
  root 'home#show'

  get '/authentication/callback' => 'authentication#callback'
  get '/authentication/failure' => 'authentication#failure'

  get '/dashboard' => 'dashboard#show'

  resource :reservations
  get '/reservations/:date' => 'reservations#show_for_date'

  resource :reservation_policies
  resource :workstations
end
