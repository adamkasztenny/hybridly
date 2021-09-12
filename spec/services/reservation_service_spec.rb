require 'rails_helper'

RSpec.describe ReservationService do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }

  let!(:admin_user) { create(:admin_user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2, user: admin_user) }
  let!(:workspace) { create(:workspace, user: reservation_policy.user) }

  context ".reservations_per_day" do
    it "returns an empty hash if there are no reservations" do
      expect(ReservationService.reservations_per_day).to eq({})
    end

    it "returns the number of reservations per day" do
      Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)

      Reservation.create!(date: Date.new(2022, 1, 1), user: second_user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 3, 1), user: second_user, verification_code: SecureRandom.uuid)

      expect(ReservationService.reservations_per_day).to eq({ Date.new(2022, 1, 1) => 2, Date.new(2022, 1, 2) => 1,
                                                              Date.new(2022, 3, 1) => 1 })
    end
  end

  context ".spots_remaining_for_today" do
    before do
      Timecop.freeze(DateTime.new(2022, 1, 2, 14, 55))
    end

    after do
      Timecop.return
    end

    it "returns the capacity if there are no reservations made" do
      spots = ReservationService.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns the capacity if there are no reservations made and reservations have been made for other days" do
      Reservation.create!(date: Date.new(2022, 1, 5), user: user, verification_code: SecureRandom.uuid)

      spots = ReservationService.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns remaining spots if reservations have been made" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)

      spots = ReservationService.spots_remaining_for_today

      expect(spots).to be 1
    end

    it "returns zero if there are no spots remaining" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 1, 2), user: second_user, verification_code: SecureRandom.uuid)

      spots = ReservationService.spots_remaining_for_today

      expect(spots).to be 0
    end
  end

  context ".for_date" do
    it "returns an empty list if there are no reservations for a particular day" do
      reservations = ReservationService.for_date(Date.new(2022, 1, 1))

      expect(reservations).to be_empty
    end

    it "returns a list of reservations for a particular day" do
      first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                             verification_code: SecureRandom.uuid)
      second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user,
                                               verification_code: SecureRandom.uuid)

      reservations = ReservationService.for_date(Date.new(2022, 1, 1))

      expect(reservations.size).to be 2
      expect(reservations).to include(first_resevation)
      expect(reservations).to include(second_reservation)
    end
  end
end
