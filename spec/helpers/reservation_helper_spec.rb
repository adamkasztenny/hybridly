require 'rails_helper'

RSpec.describe ReservationHelper do
  it "returns a message for one person in the office" do
    message = format_reservation_count(1)

    expect(message).to eq("1 person in the office")
  end

  it "returns a message for multiple people in the office" do
    message = format_reservation_count(10)

    expect(message).to eq("10 people in the office")
  end
end
