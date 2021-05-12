class InsightsService
  def self.all_reservations_per_day(start_date:, end_date:)
    reservation_counts_within_range = Reservation.group_by_day(:date).count.select do |date, count|
      date.between?(start_date, end_date)
    end

    reservation_counts_including_zero = (start_date..end_date).map do |date|
      { date => reservation_counts_within_range.fetch(date, 0) }
    end

    reservation_counts_including_zero.reduce({}) { |reservation_counts, reservation_count|
      reservation_counts.merge(reservation_count)
    }
  end

  def self.number_of_reservations(start_date:, end_date:)
    self.all_reservations_per_day(start_date: start_date, end_date: end_date).values.sum
  end

  def self.average_reservations_per_day(start_date:, end_date:)
    self.number_of_reservations(start_date: start_date,
                                end_date: end_date) / self.all_reservations_per_day(start_date: start_date,
                                                                                    end_date: end_date).size.to_f
  end

  def self.number_of_reservations_available(start_date:, end_date:)
    self.all_reservations_per_day(start_date: start_date, end_date: end_date).size * ReservationPolicy.current.capacity
  end
end
