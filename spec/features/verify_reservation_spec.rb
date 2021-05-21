require 'rails_helper'

describe "Verifying a Reservation", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy) }

  let!(:reservation) { create(:reservation, user: user) }

  it "verifies an existing reservation" do
    pending

    login_as(user.email)

    visit "/reservations/#{reservation.verification_code}/verify"

    expect(page).to have_content "Verified reservation for #{user.name} on #{reservation.date}"
  end

  it "displays an error message if the reservation does not exist" do
    pending

    login_as(user.email)

    non_existent_verification_code = SecureRandom.uuid
    visit "/reservations/#{non_existent_verification_code}/verify"

    expect(page).to have_content "Verification failed! The reservation was not found!"
  end
end
