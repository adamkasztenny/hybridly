class InsightsService
  def self.all_reservations_per_day
    Reservation.group_by_day(:date).count
  end

  def self.number_of_reservations
    self.all_reservations_per_day.values.sum
  end
end
