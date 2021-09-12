class DashboardController < ApplicationController
  include Secured

  def show
    @user = User.find(session[:user_id])
    @reservations_per_day = ReservationService.reservations_per_day.map do |date, count|
      [date, count]
    end
    @reservation_policy = ReservationPolicy.current
    @spots_remaining_for_today = ReservationPolicyService.spots_remaining_for_today
  end
end
