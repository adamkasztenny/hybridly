require 'rails_helper'

RSpec.describe AuthenticationController do
  describe "when the user does not exist in the database" do
    it "they should be redirected to the authentication failure page" do
      authenticate("does-not-exist@example.com")
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(response).to redirect_to('/authentication/failure')
    end

    it "their user information should not be stored in a session" do
      authenticate("does-not-exist@example.com")
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user]).to be nil
    end
  end

  describe "when the user does exist in the database" do
    it "they should be redirected to the dashboard page" do
      email = "does-exist@example.com"
      User.create!(email: email)

      authenticate(email)
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(response).to redirect_to('/dashboard')
    end

    it "their user information should be stored in a session" do
      email = "does-exist@example.com"
      User.create!(email: email)

      authenticate(email)
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user]).not_to be nil
      expect(session[:user][:email]).to eq(email)
    end
  end
end