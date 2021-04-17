require 'rails_helper'

describe "Reserving a spot in the office", type: :feature do
  before :each do
    user = User.create!(email: "hybridly@example.com")
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
end
