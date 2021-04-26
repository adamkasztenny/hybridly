require 'rails_helper'

RSpec.describe Workspace, workspace_type: :model do
  let!(:admin_user) { create(:admin_user) }

  it "can be valid for a desks type" do
    workspace = Workspace.new(location: "HR Office", workspace_type: :desks, capacity: 5, user: admin_user)

    expect(workspace).to be_valid
    expect(workspace.desks?).to be true
  end

  it "can be valid for a meeting room type" do
    workspace = Workspace.new(location: "Board Room", workspace_type: :meeting_room, capacity: 5,
                              user: admin_user)

    expect(workspace).to be_valid
    expect(workspace.meeting_room?).to be true
  end

  it "is still valid if the capacity is zero" do
    workspace = Workspace.new(location: "Broom Closet", workspace_type: :meeting_room, capacity: 0,
                              user: admin_user)

    expect(workspace).to be_valid
  end

  it "is still valid if the total capacity exceeds the capacity" do
    ReservationPolicy.create!(capacity: 10, user: admin_user)

    first_workspace = Workspace.new(location: "HR Office", workspace_type: :desks, capacity: 5, user: admin_user)
    expect(first_workspace).to be_valid

    second_workspace = Workspace.new(location: "Engineering", workspace_type: :desks, capacity: 10,
                                     user: admin_user)
    expect(second_workspace).to be_valid
  end

  it "is invalid if a workspace with the same location and type already exists" do
    Workspace.create!(location: "HR Office", workspace_type: :desks, capacity: 5, user: admin_user)
    workspace = Workspace.new(location: "HR Office", workspace_type: :desks, capacity: 5, user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Location with type desks already exists"])
  end

  it "is invalid if the capacity is nil" do
    workspace = Workspace.new(location: "HR Office", workspace_type: :desks, user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Capacity can't be blank",
                                                  "Capacity is not a number"])
  end

  it "is invalid if the capacity is below zero" do
    workspace = Workspace.new(location: "Broom Closet", workspace_type: :meeting_room, capacity: -1,
                              user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Capacity must be greater than or equal to 0"])
  end

  it "is invalid if the user who created the policy is not an admin" do
    regular_user = create(:user)
    workspace = Workspace.new(location: "HR Office", workspace_type: :desks, capacity: 5, user: regular_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["User is not an admin"])
  end

  it "is invalid if the location is nil" do
    workspace = Workspace.new(capacity: 5, workspace_type: :desks, user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Location can't be blank"])
  end

  it "is invalid if the location is blank" do
    workspace = Workspace.new(location: "", workspace_type: :desks, capacity: 5, user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Location can't be blank"])
  end

  it "is invalid if the type is blank" do
    workspace = Workspace.new(location: "HR Office", capacity: 5, user: admin_user)

    expect(workspace).not_to be_valid
    expect(workspace.errors.full_messages).to eq(["Workspace type can't be blank"])
  end

  context ".spots_remaining_for_today" do
    let!(:workspace) {
      Workspace.create!(location: "HR", workspace_type: :desks, capacity: 3, user: admin_user)
    }
    let!(:second_user) { create(:user, email: "hybridly-second@example.com") }
    let!(:third_user) { create(:user, email: "hybridly-third@example.com") }
    let!(:reservation_policy) { create(:reservation_policy, user: admin_user, capacity: 5) }
     
    before do
      Timecop.freeze(DateTime.new(2022, 1, 2, 14, 55))
    end

    after do
      Timecop.return
    end

    it "returns the capacity if no reservations have been made with the workspace" do
      expect(workspace.spots_remaining_for_today).to be 3
    end

    it "returns the spots remaining if reservations have been booked with the workspace" do
      create(:reservation, workspace: workspace, date: Date.today)
      create(:reservation, workspace: workspace, date: Date.today, user: second_user)

      expect(workspace.spots_remaining_for_today).to be 1
    end

    it "returns zero if the number of reservations made with the workspace equals its capcity" do
      create(:reservation, workspace: workspace, date: Date.today)
      create(:reservation, workspace: workspace, date: Date.today, user: second_user)
      create(:reservation, workspace: workspace, date: Date.today, user: third_user)

      expect(workspace.spots_remaining_for_today).to be 0
    end
  end
end
