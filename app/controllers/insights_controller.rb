class InsightsController < ApplicationController
  include Secured

  def show
    @all_reservations_per_day = Reservation.group_by_day(:date).count
    @number_of_reservations = @all_reservations_per_day.values.sum
    @average_reservations_per_day = @number_of_reservations / @all_reservations_per_day.size.to_f
  end
end
