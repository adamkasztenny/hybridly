require 'rails_helper'

describe "Reserving a spot in the office", type: :feature do
  let!(:user) { create(:user) }
  let!(:other_user) { User.create!(email: "hybridly-other@example.com") }
  let!(:admin_user) { create(:admin_user) }

  before :each do
    reservation_policy = ReservationPolicy.create!(office_limit: 1, user: admin_user)

    authenticate(user.email)

    visit '/'
    click_button 'Login'
  end

  it "allows the user to pick a date to go to the office" do
    click_button 'Reserve time in the office'
    expect(page).to have_content "New Reservation"

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).to have_content "Reservation for 2022-01-01 successful!"
  end

  it "displays an error message if no reservation date is picked" do
    click_button 'Reserve time in the office'

    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "Date can't be blank"
  end

  it "does not allow the user to reserve the same date twice" do
    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "User has already reserved 2022-01-01"
  end

  it "does not allow users to reserve a spot if the office limit has been reached for that date" do
    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    authenticate(other_user.email)
    visit '/'
    click_button 'Login'

    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"

    expect(page).not_to have_content "Reservation for 2022-01-01 successful!"
    expect(page).to have_content "Office limit has been reached for 2022-01-01"
  end

  it "does not allow users to reserve a spot if the office limit has not been reached for that date" do
    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-01'
    click_on "Create Reservation"
    expect(page).to have_content "Reservation for 2022-01-01 successful!"

    authenticate(other_user.email)
    visit '/'
    click_button 'Login'

    click_button 'Reserve time in the office'

    fill_in 'reservation_date', :with => '2022-01-02'
    click_on "Create Reservation"
    expect(page).to have_content "Reservation for 2022-01-02 successful!"
  end
end
