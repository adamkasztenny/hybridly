require 'rails_helper'

RSpec.describe CapacityHelper do
  context "Spots remaining for today" do
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
