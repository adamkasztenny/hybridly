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

  context ".reservations_per_day" do
    it "returns an empty hash if there are no reservations" do
      expect(Reservation.reservations_per_day).to eq({})
    end

    it "returns the number of reservations per day" do
      Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)

      Reservation.create!(date: Date.new(2022, 1, 1), user: second_user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 3, 1), user: second_user, verification_code: SecureRandom.uuid)

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
      Reservation.create!(date: Date.new(2022, 1, 5), user: user, verification_code: SecureRandom.uuid)

      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 2
    end

    it "returns remaining spots if reservations have been made" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)

      spots = Reservation.spots_remaining_for_today

      expect(spots).to be 1
    end

    it "returns zero if there are no spots remaining" do
      Reservation.create!(date: Date.new(2022, 1, 2), user: user, verification_code: SecureRandom.uuid)
      Reservation.create!(date: Date.new(2022, 1, 2), user: second_user, verification_code: SecureRandom.uuid)

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
      first_resevation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                             verification_code: SecureRandom.uuid)
      second_reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: second_user,
                                               verification_code: SecureRandom.uuid)

      reservations = Reservation.for_date(Date.new(2022, 1, 1))

      expect(reservations.size).to be 2
      expect(reservations).to include(first_resevation)
      expect(reservations).to include(second_reservation)
    end
  end

  context ".verify" do
    it "returns the reservation if it matches the verification code" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      verified_reservation = Reservation.verify(verification_code, admin_user)

      expect(verified_reservation.valid?).to be true
      expect(verified_reservation.id).to eq(reservation.id)
    end

    it "sets who verified the reservation" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      expect(reservation.verified_by).to be nil

      verified_reservation = Reservation.verify(verification_code, admin_user)

      expect(verified_reservation.verified_by.id).to be admin_user.id
    end

    it "returns false if the verification code does not match any reservation" do
      verification_code = SecureRandom.uuid
      non_matching_verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: non_matching_verification_code)

      verified_reservation = Reservation.verify(verification_code, admin_user)

      expect(verified_reservation).to be false
    end

    it "does not set who verified the reservation if the code does not match" do
      verification_code = SecureRandom.uuid
      non_matching_verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user,
                                        verification_code: non_matching_verification_code)

      expect(reservation.verified_by).to be nil

      Reservation.verify(verification_code, admin_user)

      expect(Reservation.find(reservation.id).verified_by).to be nil
    end

    it "does not set who verified the reservation if the verifying user is not an admin" do
      verification_code = SecureRandom.uuid
      reservation = Reservation.create!(date: Date.new(2022, 1, 1), user: user, verification_code: verification_code)

      expect(reservation.verified_by).to be nil

      reservation = Reservation.verify(verification_code, second_user)

      expect(Reservation.find(reservation.id).verified_by).to be nil
      expect(reservation.valid?).to be false
    end
  end
end
