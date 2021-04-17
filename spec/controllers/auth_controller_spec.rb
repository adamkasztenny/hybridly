require 'rails_helper'

RSpec.describe AuthController do
  describe "when the user does not exist in the database" do
    it "they should be redirected to the authentication failure page" do
      OmniAuth.config.mock_auth['extra'] = { 'raw_info' => { :name => "does-not-exist@example.com" } }
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth

      post :callback

      expect(response).to redirect_to('/auth/failure')
    end
  end

  describe "when the user does exist in the database" do
    it "they should be redirected to the dashboard page" do
      email = "does-exist@example.com"
      User.create(email: email)

      OmniAuth.config.mock_auth['extra'] = { 'raw_info' => { :name => email } }
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth

      post :callback

      expect(response).to redirect_to('/dashboard')
    end
  end
end
