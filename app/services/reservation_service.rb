class ReservationService
  def self.reservations_per_day
    Reservation.group(:date).count(:date)
  end

  def self.spots_used_today
    for_date(Date.today).count
  end

  def self.for_date(date)
    Reservation.where(date: date)
  end
end
