Rails.application.routes.draw do
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

  post "/graphql", to: "graphql#execute"
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
end
