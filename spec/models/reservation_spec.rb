require 'rails_helper'

RSpec.describe Reservation, type: :model do
  let!(:user) { create(:user) }
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }
  let!(:third_user) { create(:user, email: "hybridly-third@example.com") }

  let!(:admin_user) { create(:admin_user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2, user: admin_user) }
  let!(:workspace) { create(:workspace, user: reservation_policy.user) }

  it "can be valid without a workspace" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)

    expect(reservation).to be_valid
    expect(reservation.workspace).to be nil
  end

  it "can be valid with a workspace" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), workspace: workspace, user: user,
                                  verification_code: SecureRandom.uuid)

    expect(reservation).to be_valid
    expect(reservation.workspace).to be workspace
  end

  it "can be valid with a verifying admin user" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid,
                                  verified_by: admin_user)

    expect(reservation).to be_valid
    expect(reservation.verified_by).not_to be nil
  end

  it "does not allow a regular user to verify the reservation" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid,
                                  verified_by: second_user)

    expect(reservation).not_to be_valid
  end

  it "does not allow the same regular user to verify the reservation" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid,
                                  verified_by: user)

    expect(reservation).not_to be_valid
  end

  it "does not allow the same admin user to verify the reservation" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: admin_user, verification_code: SecureRandom.uuid,
                                  verified_by: admin_user)

    expect(reservation).not_to be_valid
  end

  it "does not allow the date to be nil" do
    reservation = Reservation.new(user: user, verification_code: SecureRandom.uuid)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["Date can't be blank"])
  end

  it "must be associated with a user" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), verification_code: SecureRandom.uuid)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["User must exist"])
  end

  it "must have a verification code" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["Verification code can't be blank"])
  end

  it "cannot have a blank verification code" do
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user,
                                  verification_code: "                         ")

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["Verification code can't be blank"])
  end

  it "does not allow the user to book the same date twice" do
    Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)
    reservation = Reservation.new(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)

    expect(reservation).not_to be_valid
    expect(reservation.errors.full_messages).to eq(["User has already reserved 2022-01-01"])
  end

  it "does not allow the user to book the date if the booking exceeds the office capacity" do
    first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)
    expect(first_resevation).to be_valid

    second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user,
                                             verification_code: SecureRandom.uuid)
    expect(second_reservation).to be_valid

    third_reservation = Reservation.new(date: Date.new(2022, 1, 1), user: third_user,
                                        verification_code: SecureRandom.uuid)

    expect(third_reservation).not_to be_valid
    expect(third_reservation.errors.full_messages).to eq(["Capacity has been reached for 2022-01-01"])
  end

  it "does not allow the user to book the date if the booking exceeds the workspace capacity" do
    first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), workspace: workspace, user: user,
                                           verification_code: SecureRandom.uuid)
    expect(first_resevation).to be_valid

    second_reservation = Reservation.new(date: Date.new(2022, 1, 1), workspace: workspace, user: second_user,
                                         verification_code: SecureRandom.uuid)
    expect(second_reservation).not_to be_valid
    expect(second_reservation.errors.full_messages).to eq(["Workspace capacity has been reached for 2022-01-01"])
  end

  it "does allow the user to book the date if the booking does not exceed the office capacity" +
     "and no workspace has been chosen" do
    first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), workspace: workspace, user: user,
                                           verification_code: SecureRandom.uuid)
    expect(first_resevation).to be_valid

    second_reservation = Reservation.new(date: Date.new(2022, 1, 1), user: second_user,
                                         verification_code: SecureRandom.uuid)
    expect(second_reservation).to be_valid
  end

  context ".verified?" do
    it "returns true if the reservation was verified" do
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: SecureRandom.uuid,
                                        verified_by: admin_user)

      expect(reservation.verified?).to be true
    end

    it "returns false if the reservation was not verified" do
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: SecureRandom.uuid)

      expect(reservation.verified?).to be false
    end
  end
end
