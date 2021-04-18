class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find(session[:user_id])
    @reservations_per_day = Reservation.reservations_per_day.map do |date, count|
      [date, count]
    end
    @reservation_policy = ReservationPolicy.current
  end
end
