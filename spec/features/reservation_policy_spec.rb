require 'rails_helper'

describe "Setting a reservation policy", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:regular_user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, user: admin_user) }

  context 'as an admin' do
    before :each do
      login_as(admin_user.email)
    end

    it 'the edit link is visible' do
      expect(page).to have_link("Update reservation policy")
    end

    it "allows the admin to set a limit on the number of employees who can be in the office" do
      click_on 'Update reservation policy'
      expect(page).to have_content "Edit Reservation Policy"

      fill_in 'reservation_policy_office_limit', :with => 2
      click_on "Update"

      expect(page).to have_content "Policy updated to permit 2 people in the office"
    end

    it "displays an error message if the limit is blank" do
      click_on 'Update reservation policy'
      click_on "Update"

      expect(page).not_to have_content "Policy updated"
      expect(page).to have_content "Office limit can't be blank"
    end
  end

  context 'as a regular employee user' do
    before :each do
      login_as(regular_user.email)
    end

    it 'the edit link is not visible' do
      expect(page).not_to have_link("Update reservation policy")
    end
  end
end
