class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find(session[:user_id])
  end
end
