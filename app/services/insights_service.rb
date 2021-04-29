class InsightsService
  def self.all_reservations_per_day
    Reservation.group_by_day(:date).count
  end
end
