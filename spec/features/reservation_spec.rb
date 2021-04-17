require 'rails_helper'

describe "Reserving a spot in the office", type: :feature do
  before :each do
    user = User.create!(email: "hybridly@example.com")
    authenticate(user.email)

    visit '/'
    click_button 'Login'
  end

  it "allows the user to pick a date to go to the office, if the limit is not reached" do
    pending

    click_button 'Reserve time in the office'

    fill_in 'date', :with => '2022-01-01'

    expect(page).to have_content "Reservation for Jan 1st, 2022 successful!"
  end
end
