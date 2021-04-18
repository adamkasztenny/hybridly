require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { User.new(email: "hybridly@example.com") }
  let(:second_user) { User.new(email: "hybridly-second@example.com") }
  let(:third_user) { User.new(email: "hybridly-third@example.com") }

  before do
    admin_user = User.new(email: "hybridly-admin@example.com")
    admin_user.add_role(:admin)
    ReservationPolicy.create!(office_limit: 2, user: admin_user)
  end

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

  it "does not allow the user to book the date if the booking exceeds the office limit" do
    first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user)
    expect(first_resevation).to be_valid

    second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user)
    expect(second_reservation).to be_valid

    third_reservation = Reservation.new(date: Date.new(2022, 1, 1), user: third_user)

    expect(third_reservation).not_to be_valid
    expect(third_reservation.errors.full_messages).to eq(["Office limit has been reached for 2022-01-01"])
  end
end
