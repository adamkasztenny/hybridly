class InsightsService
  def self.all_reservations_per_day
    Reservation.group_by_day(:date).count
  end

  def self.number_of_reservations
    self.all_reservations_per_day.values.sum
  end

  def self.average_reservations_per_day
    if self.all_reservations_per_day.empty?
      return 0
    end

    self.number_of_reservations / self.all_reservations_per_day.size.to_f
  end

  def self.number_of_reservations_available
    self.all_reservations_per_day.size * ReservationPolicy.current.capacity
  end
end
