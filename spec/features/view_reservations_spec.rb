require 'rails_helper'

describe "Dashboard", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy) }
  let!(:reservation) { create(:reservation, user: create(:user, email: "other-hybridly@example.com")) }

  before do
    Timecop.freeze(Time.parse('2022-01-01'))
  end

  after do
    Timecop.return
  end

  it "allows the user to click a day on the calendar and view a reservation" do
    pending

    login_as(user.email)

    click_on "1 person in the office"

    expect(page).to have_content "Reservations for 2022-01-01"
    expect(page).to have_content "1 person in the office"
    expect(page).to have_content "other-hybridly@example.com"
  end
end
