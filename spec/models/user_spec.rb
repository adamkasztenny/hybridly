require 'rails_helper'

RSpec.describe User, type: :model do
  it "can be valid" do
    user = User.new(email: "hybridly@example.com")

    expect(user).to be_valid
  end

  it "does not allow the email to be nil" do
    user = User.new

    expect(user).not_to be_valid
    expect(user.errors.full_messages).to eq(["Email can't be blank"])
  end

  it "not allow the email to be blank" do
    user = User.new(email: "")

    expect(user).not_to be_valid
    expect(user.errors.full_messages).to eq(["Email can't be blank"])
  end

  it "enforces a unique email constraint" do
    first_user = User.new(email: "hybridly@example.com")
    first_user.save!

    second_user = User.new(email: "hybridly@example.com")
    expect(second_user).not_to be_valid
    expect(second_user.errors.full_messages).to eq(["Email has already been taken"])
  end

  it "should be a regular employee user by default" do
    user = User.create!(email: "hybridly@example.com")

    expect(user.has_role?(:employee)).to be true
  end

  it "should not be an admin user by default" do
    user = User.create!(email: "hybridly@example.com")

    expect(user.has_role?(:admin)).to be false
  end
end
