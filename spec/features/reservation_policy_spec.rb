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
      click_button 'Update reservation policy'
      expect(page).to have_content "Update Reservation Policy"

      fill_in 'reservation_policy_office_limit', :with => 2
      click_on "Update reservation policy"

      expect(page).to have_content "Policy updated to permit 2 people in the office"
    end

    it "displays an error message if the limit is blank" do
      click_button 'Update reservation policy'
      click_on "Update reservation policy"

      expect(page).not_to have_content "Policy updated"
      expect(page).to have_content "Office limit can't be blank"
    end
  end

  context 'as a regular employee user' do
    before :each do
      regular_user = create(:user)
      authenticate(regular_user.email)

      visit '/'
      click_button 'Login'
    end

    it 'the edit button is not visible' do
      expect(page).not_to have_button("Update reservation policy")
    end
  end
end
