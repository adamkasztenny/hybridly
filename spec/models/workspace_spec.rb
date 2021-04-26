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
end
