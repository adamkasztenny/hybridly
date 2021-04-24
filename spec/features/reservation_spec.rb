require 'rails_helper'

describe "Reserving a spot in the office", type: :feature do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, email: "hybridly-other@example.com") }
  let!(:reservation_policy) { create(:reservation_policy) }

  before :each do
    login_as(user.email)
  end

  it "allows the user to pick a date to go to the office" do
    click_on 'Reserve time in the office'
    expect(page).to have_content "New Reservation"

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).to have_content "Reservation for 2022-01-01 successful!"
  end

  it "displays an error message if no reservation date is picked" do
    click_on 'Reserve time in the office'

    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "Date can't be blank"
  end

  it "does not allow the user to reserve the same date twice" do
    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "User has already reserved 2022-01-01"
  end

  it "does not allow users to reserve a spot if the capacity has been reached for that date" do
    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    login_as(other_user.email)

    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "Capacity has been reached for 2022-01-01"
  end

  it "does not allow users to reserve a spot if the capacity has not been reached for that date" do
    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"
    expect(page).to have_content "Reservation for 2022-01-01 successful!"

    login_as(other_user.email)

    click_on 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-02'
    click_on "Create Reservation"
    expect(page).to have_content "Reservation for 2022-01-02 successful!"
  end
end
