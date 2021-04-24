require 'rails_helper'

describe "Creating a workstation", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:regular_user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, user: admin_user) }

  context 'as an admin' do
    before :each do
      login_as(admin_user.email)
    end

    it 'the edit link is visible' do
      pending

      expect(page).to have_link("Create workstation")
    end

    it "allows the admin to set a limit on the number of employees who can be in the office" do
      pending

      click_on 'Create workstation'
      expect(page).to have_content "Create Workstation"

      fill_in 'workstation_location', :with => 'Engineering'
      fill_in 'workstation_capacity', :with => 5
      click_on "Create"

      expect(page).to have_content "Engineering workstation created with a capacity of 5 people"
    end

    it "displays an error message if the location is blank" do
      pending

      click_on 'Create Workstation'

      fill_in 'workstation_capacity', :with => 5
      click_on "Create"

      expect(page).not_to have_content "Engineering workstation created"
      expect(page).to have_content "Location can't be blank"
    end

    it "displays an error message if the capacity is not provided" do
      pending

      click_on 'Create Workstation'

      fill_in 'workstation_location', :with => 'Engineering'
      click_on "Create"

      expect(page).not_to have_content "Engineering workstation created"
      expect(page).to have_content "Location can't be blank"
    end
  end

  context 'as a regular employee user' do
    before :each do
      login_as(regular_user.email)
    end

    it 'the edit link is not visible' do
      expect(page).not_to have_link("Create workstation")
    end
  end
end
