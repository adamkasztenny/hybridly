class InsightsController < ApplicationController
  include Secured

  def show
    start_date = params.fetch(:start_date, Date.today.last_month).to_date
    end_date = params.fetch(:end_date, Date.today).to_date

    @all_reservations_per_day = InsightsService.all_reservations_per_day(start_date: start_date, end_date: end_date)
    @number_of_reservations = InsightsService.number_of_reservations(start_date: start_date, end_date: end_date)
    @average_reservations_per_day = InsightsService.average_reservations_per_day(start_date: start_date,
                                                                                 end_date: end_date)
    @reservations_used_vs_available = { :Used => @number_of_reservations,
                                        :Available => InsightsService.number_of_reservations_available(
                                          start_date: start_date, end_date: end_date
                                        ) }
  end
end
