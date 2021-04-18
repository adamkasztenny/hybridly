class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find(session[:user_id])
    @reservations_by_date = Reservation.group(:date).count(:date).map do |date, count|
      [date, count]
    end
  end
end
