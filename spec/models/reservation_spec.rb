require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let(:user) { User.new(email: "hybridly@example.com") }

  it "can be valid" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user)

    expect(reservation).to be_valid
  end

  it "does not allow the date to be nil" do
    reservation = Reservation.new(user: user)

    expect(reservation).not_to be_valid
  end

  it "must be associated with a user" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1))

    expect(reservation).not_to be_valid
  end
end
