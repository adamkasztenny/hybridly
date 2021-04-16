require 'rails_helper'

RSpec.describe User, type: :model do
  it "can be valid" do
    user = User.new(email: "hybridly@example.com")

    expect(user).to be_valid
  end

  it "not allow the email to be nil" do
    user = User.new

    expect(user).not_to be_valid
  end

  it "not allow the email to be blank" do
    user = User.new(email: "")

    expect(user).not_to be_valid
  end

  it "enforces a unique email constraint" do
    first_user = User.new(email: "hybridly@example.com")
    first_user.save!

    second_user = User.new(email: "hybridly@example.com")
    expect(second_user).not_to be_valid
  end
end
