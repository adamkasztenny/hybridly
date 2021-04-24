require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:user) { create(:user) }
  let(:second_user) { create(:user, email: "hybridly-second@example.com") }
  let(:third_user) { create(:user, email: "hybridly-third@example.com") }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2) }

  it "can be valid" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user)

    expect(reservation).to be_valid
  end

  it "does not allow the date to be nil" do
    reservation = Reservation.new(user: user)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["Date can't be blank"])
  end

  it "must be associated with a user" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1))

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["User must exist"])
  end

  it "does not allow the user to book the same date twice" do
    Reservation.create!(date: Date.new(2022, 1, 1), user: user)
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["User has already reserved 2022-01-01"])
  end

  it "does not allow the user to book the date if the booking exceeds the capacity" do
    first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user)
    expect(first_resevation).to be_valid

    second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user)
    expect(second_reservation).to be_valid

    third_reservation = Reservation.new(date: Date.new(2022, 1, 1), user: third_user)

    expect(third_reservation).not_to be_valid
    expect(third_reservation.errors.full_messages).to eq(["Capacity has been reached for 2022-01-01"])
  end

  context ".reservations_per_day" do
    it "returns an empty hash if there are no reservations" do
      expect(Reservation.reservations_per_day).to eq({})
    end

    it "returns the number of reservations per day" do
      Reservation.create!(date: Date.new(2022, 1, 1), user: user)
      Reservation.create!(date: Date.new(2022, 1, 2), user: user)

      Reservation.create!(date: Date.new(2022, 1, 1), user: second_user)
      Reservation.create!(date: Date.new(2022, 3, 1), user: second_user)

      expect(Reservation.reservations_per_day).to eq({ Date.new(2022, 1, 1) => 2, Date.new(2022, 1, 2) => 1,
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
      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns the capacity if there are no reservations made and reservations have been made for other days" do
      Reservation.create!(date: Date.new(2022, 1, 5), user: user)

      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns remaining spots if reservations have been made" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user)

      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 1
    end

    it "returns zero if there are no spots remaining" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user)
      Reservation.create!(date: Date.new(2022, 1, 2), user: second_user)

      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 0
    end
  end

  context ".for_date" do
    it "returns an empty list if there are no reservations for a particular day" do
      reservations = Reservation.for_date(Date.new(2022, 1, 1))

      expect(reservations).to be_empty
    end

    it "returns a list of reservations for a particular day" do
      first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user)
      second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user)

      reservations = Reservation.for_date(Date.new(2022, 1, 1))

      expect(reservations.size).to be 2
      expect(reservations).to include(first_resevation)
      expect(reservations).to include(second_reservation)
    end
  end
end
