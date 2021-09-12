class ReservationPolicyService
  def self.spots_remaining_for_today
    number_of_used_spots = ReservationService.spots_used_today
    ReservationPolicy.current.spots_remaining(number_of_used_spots)
  end
end
