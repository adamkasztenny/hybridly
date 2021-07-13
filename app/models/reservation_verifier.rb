class ReservationVerifier
  def self.verify(verification_code, user)
    reservation = Reservation.find_by(verification_code: verification_code)
    if reservation.nil?
      return false
    end

    reservation.verified_by = user
    reservation.save
    reservation
  end
end
