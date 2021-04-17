class DashboardController < ApplicationController
  include Secured

  def show
    @user = session[:user]
  end
end
