class ReservationService
  def self.reservations_per_day
    Reservation.group(:date).count(:date)
  end

  def self.spots_remaining_for_today
    used_spots = Reservation.where(date: Date.today).count
    capacity = ReservationPolicy.current.capacity
    capacity - used_spots
  end

  def self.for_date(date)
    Reservation.where(date: date)
  end
end
