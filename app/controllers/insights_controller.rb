class InsightsController < ApplicationController
  include Secured

  def show
    @all_reservations_per_day = InsightsService.all_reservations_per_day
    @number_of_reservations = InsightsService.number_of_reservations
    @average_reservations_per_day = InsightsService.average_reservations_per_day
    @reservations_used_vs_available = { :Used => @number_of_reservations,
                                        :Available => InsightsService.number_of_reservations_available }
  end
end
