require 'rails_helper'

RSpec.describe Workstation, workstation_type: :model do
  let!(:admin_user) { create(:admin_user) }

  it "can be valid for a desk type" do
    workstation = Workstation.new(location: "HR Office", workstation_type: :desk, capacity: 5, user: admin_user)

    expect(workstation).to be_valid
    expect(workstation.desk?).to be true
  end

  it "can be valid for a meeting room type" do
    workstation = Workstation.new(location: "Board Room", workstation_type: :meeting_room, capacity: 5,
                                  user: admin_user)

    expect(workstation).to be_valid
    expect(workstation.meeting_room?).to be true
  end

  it "is still valid if the capacity is zero" do
    workstation = Workstation.new(location: "Broom Closet", workstation_type: :meeting_room, capacity: 0,
                                  user: admin_user)

    expect(workstation).to be_valid
  end

  it "is still valid if the total capacity exceeds the capacity" do
    ReservationPolicy.create!(capacity: 10, user: admin_user)

    first_workstation = Workstation.new(location: "HR Office", workstation_type: :desk, capacity: 5, user: admin_user)
    expect(first_workstation).to be_valid

    second_workstation = Workstation.new(location: "Engineering", workstation_type: :desk, capacity: 10,
                                         user: admin_user)
    expect(second_workstation).to be_valid
  end

  it "is invalid if the capacity is nil" do
    workstation = Workstation.new(location: "HR Office", workstation_type: :desk, user: admin_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["Capacity can't be blank",
                                                    "Capacity is not a number"])
  end

  it "is invalid if the capacity is below zero" do
    workstation = Workstation.new(location: "Broom Closet", workstation_type: :meeting_room, capacity: -1,
                                  user: admin_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["Capacity must be greater than or equal to 0"])
  end

  it "is invalid if the user who created the policy is not an admin" do
    regular_user = create(:user)
    workstation = Workstation.new(location: "HR Office", workstation_type: :desk, capacity: 5, user: regular_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["User is not an admin"])
  end

  it "is invalid if the location is nil" do
    workstation = Workstation.new(capacity: 5, workstation_type: :desk, user: admin_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["Location can't be blank"])
  end

  it "is invalid if the location is blank" do
    workstation = Workstation.new(location: "", workstation_type: :desk, capacity: 5, user: admin_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["Location can't be blank"])
  end

  it "is invalid if the type is blank" do
    workstation = Workstation.new(location: "HR Office", capacity: 5, user: admin_user)

    expect(workstation).not_to be_valid
    expect(workstation.errors.full_messages).to eq(["Workstation type can't be blank"])
  end
end
