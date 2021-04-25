require 'rails_helper'

describe "Creating a workspace", type: :feature do
  let!(:admin_user) { create(:admin_user) }
  let!(:regular_user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, user: admin_user) }

  context 'as an admin' do
    before :each do
      login_as(admin_user.email)
    end

    it 'the create link is visible' do
      expect(page).to have_link("Create Workspace")
    end

    it "allows the admin to create a workspace with desks" do
      click_on 'Create Workspace'
      expect(page).to have_content "Create Workspace"

      fill_in 'workspace_location', :with => 'Engineering'
      select 'Desk', :from => 'workspace_workspace_type'
      fill_in 'workspace_capacity', :with => 5
      click_on "Create"

      expect(page).to have_content "Engineering workspace created with a capacity of 5 people"
    end

    it "allows the admin to create a workspace that is a meeting room" do
      click_on 'Create Workspace'
      expect(page).to have_content "Create Workspace"

      fill_in 'workspace_location', :with => 'Board Room'
      select 'Meeting room', :from => 'workspace_workspace_type'
      fill_in 'workspace_capacity', :with => 10
      click_on "Create"

      expect(page).to have_content "Board Room workspace created with a capacity of 10 people"
    end

    it "displays an error message if the location is blank" do
      click_on 'Create Workspace'

      fill_in 'workspace_capacity', :with => 5
      select 'Desk', :from => 'workspace_workspace_type'
      click_on "Create"

      expect(page).not_to have_content "Engineering workspace created"
      expect(page).to have_content "Location can't be blank"
    end

    it "displays an error message if the capacity is not provided" do
      click_on 'Create Workspace'

      fill_in 'workspace_location', :with => 'Engineering'
      select 'Desk', :from => 'workspace_workspace_type'
      click_on "Create"

      expect(page).not_to have_content "Engineering workspace created"
      expect(page).to have_content "Capacity can't be blank"
    end
  end

  context 'as a regular employee user' do
    before :each do
      login_as(regular_user.email)
    end

    it 'the create link is not visible' do
      expect(page).not_to have_link("Create workspace")
    end
  end
end
