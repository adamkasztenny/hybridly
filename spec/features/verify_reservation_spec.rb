require 'rails_helper'

describe "Verifying a Reservation", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:regular_user) { create(:user) }

  let!(:reservation_policy) { create(:reservation_policy, user: admin_user) }
  let!(:reservation) { create(:reservation, user: regular_user) }

  context "as an admin" do
    before :each do
      login_as(admin_user.email)
    end

    it "verifies an existing reservation" do
      visit "/reservations/#{reservation.verification_code}/verify"

      expect(page).to have_content "Verified reservation for #{regular_user.email} on #{reservation.date}"
    end

    it "displays an error message if the reservation does not exist" do
      non_existent_verification_code = SecureRandom.uuid
      visit "/reservations/#{non_existent_verification_code}/verify"

      expect(page).to have_content "Verification failed! The reservation was not found!"
    end
  end

  context 'as a regular employee user' do
    before :each do
      login_as(regular_user.email)
    end

    it 'the reservation cannot be verified if it exists' do
      visit "/reservations/#{reservation.verification_code}/verify"

      expect(page).to have_content "Not Authorized"
      expect(page).not_to have_content "Verified reservation for #{regular_user.email} on #{reservation.date}"
    end

    it 'the reservation cannot be verified if it does not exist' do
      visit "/reservations/#{reservation.verification_code}/verify"

      expect(page).to have_content "Not Authorized"
      expect(page).not_to have_content "Verification failed! The reservation was not found!"
    end
  end
end
