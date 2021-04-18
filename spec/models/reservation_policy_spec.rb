require 'rails_helper'

RSpec.describe ReservationPolicy, type: :model do
  let!(:admin_user) { create(:admin_user) }

  it "can be valid" do
    reservation_policy = ReservationPolicy.new(office_limit: 100, user: admin_user)

    expect(reservation_policy).to be_valid
  end

  it "is still valid if the office limit is zero" do
    reservation_policy = ReservationPolicy.new(office_limit: 0, user: admin_user)

    expect(reservation_policy).to be_valid
  end

  it "is invalid if the office limit is nil" do
    reservation_policy = ReservationPolicy.new(user: admin_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["Office limit can't be blank",
                                                           "Office limit is not a number"])
  end

  it "is invalid if the office limit is below zero" do
    reservation_policy = ReservationPolicy.new(office_limit: -1, user: admin_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["Office limit must be greater than or equal to 0"])
  end

  it "is invalid if the user who created the policy is not an admin" do
    regular_user = create(:user)
    reservation_policy = ReservationPolicy.new(office_limit: 100, user: regular_user)

    expect(reservation_policy).not_to be_valid
    expect(reservation_policy.errors.full_messages).to eq(["User is not an admin"])
  end

  it "exposes the current policy in effect" do
    expect(ReservationPolicy.current).to be nil

    reservation_policy = ReservationPolicy.create!(office_limit: 100, user: admin_user)

    expect(ReservationPolicy.current).to eq(reservation_policy)
  end

  it "always uses the latest policy as the current policy" do
    ReservationPolicy.create!(office_limit: 75, user: admin_user)
    ReservationPolicy.create!(office_limit: 10, user: admin_user)
    ReservationPolicy.create!(office_limit: 100, user: admin_user)
    latest_policy = ReservationPolicy.create!(office_limit: 25, user: admin_user)

    expect(ReservationPolicy.current).to eq(latest_policy)
  end
end
