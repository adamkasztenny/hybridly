class InsightsController < ApplicationController
  include Secured

  def show
    @reservations_per_day = Reservation.group_by_day(:date).count
  end
end
