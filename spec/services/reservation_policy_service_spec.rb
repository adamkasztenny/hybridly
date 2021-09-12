require 'rails_helper'

RSpec.describe ReservationPolicyService do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }

  let!(:admin_user) { create(:admin_user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2, user: admin_user) }

  context ".spots_remaining_for_today" do
    before do
      Timecop.freeze(DateTime.new(2022, 1, 2, 14, 55))
    end

    after do
      Timecop.return
    end

    it "returns the capacity if there are no reservations made" do
      spots = ReservationPolicyService.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns the capacity if there are no reservations made and reservations have been made for other days" do
      Reservation.create!(date: Date.new(2022, 1, 5), user: user, verification_code: SecureRandom.uuid)

      spots = ReservationPolicyService.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns remaining spots if reservations have been made" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)

      spots = ReservationPolicyService.spots_remaining_for_today

      expect(spots).to be 1
    end

    it "returns zero if there are no spots remaining" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 1, 2), user: second_user, verification_code: SecureRandom.uuid)

      spots = ReservationPolicyService.spots_remaining_for_today

      expect(spots).to be 0
    end
  end
end
