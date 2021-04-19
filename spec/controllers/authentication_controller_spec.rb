require 'rails_helper'

RSpec.describe AuthenticationController do
  describe "when the user does not exist in the database" do
    before do
      authenticate("does-not-exist@example.com")
    end

    it "they should be redirected to the authentication failure page" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(response).to redirect_to('/authentication/failure')
    end

    it "their user id should not be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_id]).to be nil
    end

    it "their user email should not be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_email]).to be nil
    end

    it "their user image should not be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_image]).to be nil
    end
  end

  describe "when the user does exist in the database" do
    let!(:user) { create(:user) }

    before do
      authenticate(user.email)
    end

    it "they should be redirected to the dashboard page" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(response).to redirect_to('/dashboard')
    end

    it "their user id should be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_id]).not_to be nil
    end

    it "their user email should be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_email]).not_to be nil
    end

    it "their user image should be stored in a session" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:auth0]

      post :callback

      expect(session[:user_image]).not_to be nil
    end
  end
end
