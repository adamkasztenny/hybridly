require 'rails_helper'

RSpec.describe ReservationHelper do
  context "Reservation count" do
    it "returns a message for no people in the office" do
      message = format_reservation_count(0)

      expect(message).to eq("No people in the office")
    end

    it "returns a message for one person in the office" do
      message = format_reservation_count(1)

      expect(message).to eq("1 person in the office")
    end

    it "returns a message for multiple people in the office" do
      message = format_reservation_count(10)

      expect(message).to eq("10 people in the office")
    end
  end

  context "Spots remaining" do
    it "returns a message for no spots remaining" do
      message = format_spots_remaining(0)

      expect(message).to eq("No spots remaining for today")
    end

    it "returns a message for one person in the office" do
      message = format_spots_remaining(1)

      expect(message).to eq("1 spot remaining for today")
    end

    it "returns a message for multiple people in the office" do
      message = format_spots_remaining(10)

      expect(message).to eq("10 spots remaining for today")
    end
  end
end
