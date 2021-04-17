require 'rails_helper'

RSpec.describe Secured, type: :controller do
  controller(ApplicationController) do
    include Secured

    def fake_action
      redirect_to '/fake'
    end
  end

  before do
    routes.draw {
      get 'fake_action' => 'anonymous#fake_action'
    }
  end

  describe "when the user is logged in" do
    it "they should be not redirected to the login page" do
      session[:user] = User.create(email: "test@example.com")

      get :fake_action

      expect(response).not_to redirect_to('/')
      expect(response).to redirect_to('/fake')
    end
  end

  describe "when the user is not logged in" do
    it "they should be redirected to the home page" do
      get :fake_action

      expect(response).to redirect_to('/')
      expect(response).not_to redirect_to('/fake')
    end
  end
end
