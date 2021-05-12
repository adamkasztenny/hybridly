class InsightsController < ApplicationController
  include Secured

  def show
    start_date = params.fetch(:start_date, Date.today.last_month).to_date
    end_date = params.fetch(:end_date, Date.today).to_date

    insights_service = InsightsService.new(start_date: start_date, end_date: end_date)

    @all_reservations_per_day = insights_service.all_reservations_per_day
    @number_of_reservations = insights_service.number_of_reservations
    @average_reservations_per_day = insights_service.average_reservations_per_day
    @reservations_used_vs_available = { :Used => @number_of_reservations,
                                        :Available => insights_service.number_of_reservations_available }
  end
end
