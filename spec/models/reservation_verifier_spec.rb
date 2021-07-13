require 'rails_helper'

RSpec.describe ReservationVerifier do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }

  let!(:admin_user) { create(:admin_user) }
  let!(:reservation_policy) { create(:reservation_policy, user: admin_user) }

  context ".verify" do
    it "returns the reservation if it matches the verification code" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      verified_reservation = ReservationVerifier.verify(verification_code, admin_user)

      expect(verified_reservation.valid?).to be true
      expect(verified_reservation.id).to eq(reservation.id)
    end

    it "sets who verified the reservation" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      expect(reservation.verified_by).to be nil

      verified_reservation = ReservationVerifier.verify(verification_code, admin_user)

      expect(verified_reservation.verified_by.id).to be admin_user.id
    end

    it "returns false if the verification code does not match any reservation" do
      verification_code = SecureRandom.uuid
      non_matching_verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: non_matching_verification_code)

      verified_reservation = ReservationVerifier.verify(verification_code, admin_user)

      expect(verified_reservation).to be false
    end

    it "does not set who verified the reservation if the code does not match" do
      verification_code = SecureRandom.uuid
      non_matching_verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: non_matching_verification_code)

      expect(reservation.verified_by).to be nil

      ReservationVerifier.verify(verification_code, admin_user)

      expect(Reservation.find(reservation.id).verified_by).to be nil
    end

    it "does not set who verified the reservation if the verifying user is not an admin" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      expect(reservation.verified_by).to be nil

      reservation = ReservationVerifier.verify(verification_code, second_user)

      expect(Reservation.find(reservation.id).verified_by).to be nil
      expect(reservation.valid?).to be false
    end
  end
end
