module Authentication
  def authenticate(email)
    OmniAuth.config.mock_auth[:auth0] = { 'extra' => { 'raw_info' => { :name => email } } }
  end
end
