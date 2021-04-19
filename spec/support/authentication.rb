module Authentication
  def authenticate(email)
    OmniAuth.config.mock_auth[:auth0] =
      { 'extra' => { 'raw_info' => { :name => email, :picture => 'http://example.com/img.jpeg' } } }
  end

  def login_as(email)
    authenticate(email)
    visit '/'
    click_button 'Login'
  end
end
