require 'rails_helper'

RSpec.describe ReservationPolicy, type: :model do
  let!(:admin_user) { create(:admin_user) }

  it "can be valid" do
    reservation_policy = ReservationPolicy.new(capacity: 100, user: admin_user)

    expect(reservation_policy).to be_valid
  end

  it "is still valid if the capacity is zero" do
    reservation_policy = ReservationPolicy.new(capacity: 0, user: admin_user)

    expect(reservation_policy).to be_valid
  end

  it "is invalid if the capacity is nil" do
    reservation_policy = ReservationPolicy.new(user: admin_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["Capacity can't be blank",
                                                           "Capacity is not a number"])
  end

  it "is invalid if the capacity is below zero" do
    reservation_policy = ReservationPolicy.new(capacity: -1, user: admin_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["Capacity must be greater than or equal to 0"])
  end

  it "is invalid if the user who created the policy is not an admin" do
    regular_user = create(:user)
    reservation_policy = ReservationPolicy.new(capacity: 100, user: regular_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["User is not an admin"])
  end

  it "exposes the current policy in effect" do
    expect(ReservationPolicy.current).to be nil

    reservation_policy = ReservationPolicy.create!(capacity: 100, user: admin_user)

    expect(ReservationPolicy.current).to eq(reservation_policy)
  end

  it "always uses the latest policy as the current policy" do
    ReservationPolicy.create!(capacity: 75, user: admin_user)
    ReservationPolicy.create!(capacity: 10, user: admin_user)
    ReservationPolicy.create!(capacity: 100, user: admin_user)
    latest_policy = ReservationPolicy.create!(capacity: 25, user: admin_user)

    expect(ReservationPolicy.current).to eq(latest_policy)
  end

  context ".exceeds_capacity?" do
    before do
      ReservationPolicy.create!(capacity: 10, user: admin_user)
    end

    it "returns true if the number of reservations exceed the current capacity" do
      expect(ReservationPolicy.exceeds_capacity?(50)).to be true
    end

    it "returns false if the number of reservations does not exceed the current capacity" do
      expect(ReservationPolicy.exceeds_capacity?(1)).to be false
    end
  end

  context ".spots_remaining" do
    let!(:reservation_policy) { ReservationPolicy.create!(capacity: 2, user: admin_user) }

    it "returns the capacity if there are no reservations made" do
      number_of_reservations = 0

      spots = reservation_policy.spots_remaining(number_of_reservations)

      expect(spots).to be 2
    end

    it "returns remaining spots if reservations have been made" do
      number_of_reservations = 1

      spots = reservation_policy.spots_remaining(number_of_reservations)

      expect(spots).to be 1
    end

    it "returns zero if there are no spots remaining" do
      number_of_reservations = 2

      spots = reservation_policy.spots_remaining(number_of_reservations)

      expect(spots).to be 0
    end

    it "returns zero if there are more reservations than the policy allows for" do
      number_of_reservations = 5

      spots = reservation_policy.spots_remaining(number_of_reservations)

      expect(spots).to be 0
    end
  end
end
