class InsightsController < ApplicationController
  include Secured

  def show
    @all_reservations_per_day = InsightsService.all_reservations_per_day
    @number_of_reservations = @all_reservations_per_day.values.sum
    @average_reservations_per_day = @number_of_reservations / @all_reservations_per_day.size.to_f
    @average_reservations_per_day = @number_of_reservations / @all_reservations_per_day.size.to_f
    @reservations_used_vs_available = { :Used => @number_of_reservations,
                                        :Available =>
    @all_reservations_per_day.size * ReservationPolicy.current.capacity }
  end
end
