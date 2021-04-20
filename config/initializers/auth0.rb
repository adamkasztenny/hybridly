AUTH0_CONFIG = Rails.application.config_for(:auth0)

Rails.logger.info "Using Auth0 domain #{AUTH0_CONFIG['auth0_domain']}"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider(
    :auth0,
    AUTH0_CONFIG['auth0_client_id'],
    AUTH0_CONFIG['auth0_client_secret'],
    AUTH0_CONFIG['auth0_domain'],
    callback_path: '/authentication/callback',
    authorize_params: {
      scope: 'openid profile'
    }
  )
end
