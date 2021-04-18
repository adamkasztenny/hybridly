require 'rails_helper'

RSpec.describe ReservationPolicyHelper do
  it "returns a message for no people allowed in the office" do
    message = format_reservation_policy_count(0)

    expect(message).to eq("A total of 0 people are allowed in the office")
  end

  it "returns a message for one person in the office" do
    message = format_reservation_policy_count(1)

    expect(message).to eq("A total of 1 person is allowed in the office")
  end

  it "returns a message for multiple people in the office" do
    message = format_reservation_policy_count(10)

    expect(message).to eq("A total of 10 people are allowed in the office")
  end
end
