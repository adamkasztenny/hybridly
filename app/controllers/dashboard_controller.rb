class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find(session[:user]["id"])
  end
end
