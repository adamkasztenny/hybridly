require 'rails_helper'

describe "Setting a reservation policy", type: :feature do
  context 'as an admin' do
    before :each do
      admin_user = User.create!(email: "hybridly-admin@example.com")
      admin_user.add_role(:admin)
      authenticate(admin_user.email)

      visit '/'
      click_button 'Login'
    end

    it "allows the admin to set a limit on the number of employees who can be in the office" do
      pending

      click_button 'Edit reservation policy'
      expect(page).to have_content "Edit Reservation Policy"

      fill_in 'reservation_policy_office_limit', :with => '2'
      click_on "Edit Reservation Policy"

      expect(page).to have_content "Reservation policy updated!"
    end

    it "displays an error message if the limit is blank" do
      pending

      click_button 'Reserve time in the office'

      click_on "Edit Reservation Policy"

      expect(page).not_to have_content "Reservation policy updated!"
      expect(page).to have_content "Office limit can't be blank"
    end
  end

  context 'as a regular employee user' do
    before :each do
      regular_user = User.create!(email: "hybridly@example.com")
      authenticate(regular_user.email)

      visit '/'
      click_button 'Login'
    end

    it 'the edit button is not visible' do
      expect(page).not_to have_button("Edit reservation policy")
    end
  end
end
