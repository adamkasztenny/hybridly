class InsightsService
  def initialize(start_date:, end_date:)
    @start_date = start_date
    @end_date = end_date
  end

  def all_reservations_per_day
    reservation_counts_within_range = Reservation.group_by_day(:date).count.select do |date, count|
      date.between?(@start_date, @end_date)
    end

    reservation_counts_including_zero = (@start_date..@end_date).map do |date|
      { date => reservation_counts_within_range.fetch(date, 0) }
    end

    reservation_counts_including_zero.reduce({}) { |reservation_counts, reservation_count|
      reservation_counts.merge(reservation_count)
    }
  end

  def number_of_reservations
    all_reservations_per_day.values.sum
  end

  def average_reservations_per_day
    number_of_reservations / all_reservations_per_day.size.to_f
  end

  def number_of_reservations_available
    (all_reservations_per_day.size * ReservationPolicy.current.capacity) - number_of_reservations
  end
end
