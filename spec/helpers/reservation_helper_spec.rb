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

  context ".icon_for" do
    let!(:reservation_policy) { create(:reservation_policy) }
    let(:reservation) { create(:reservation) }

    it "returns a checkmark if the reservation is verified" do
      reservation.verified_by = reservation_policy.user

      expect(icon_for(reservation)).to eq("&#10004;")
    end

    it "returns an X if the reservation is not verified" do
      reservation.verified_by = nil

      expect(icon_for(reservation)).to eq("&#10060;")
    end
  end
end
