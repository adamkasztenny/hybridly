require 'rails_helper'

RSpec.describe InsightsService do
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }
  let(:start_date) { Date.new(2022, 1, 1) }
  let(:end_date) { Date.new(2022, 1, 3) }
  let(:service) { InsightsService.new(start_date: start_date, end_date: end_date) }

  before do
    create(:reservation_policy, capacity: 2)
  end

  context ".all_reservations_per_day" do
    it "returns an empty hash if there are no reservations" do
      expect(service.all_reservations_per_day).to be {}
    end

    it "returns a single date with a count of one if a user has made a reservation" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(service.all_reservations_per_day).to eq(
        { Date.new(2022, 1, 1) => 1,
          Date.new(2022, 1, 2) => 0,
          Date.new(2022, 1, 3) => 0, }
      )
    end

    it "returns a single date with a count of two if two users have made a reservation on the same day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(service.all_reservations_per_day).to eq(
        { Date.new(2022, 1, 1) => 2,
          Date.new(2022, 1, 2) => 0,
          Date.new(2022, 1, 3) => 0 }
      )
    end

    it "returns a two dates with a count of one if two users have made a reservation on the different days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(service.all_reservations_per_day).to eq(
        { Date.new(2022, 1, 1) => 1,
          Date.new(2022, 1, 2) => 1,
          Date.new(2022, 1, 3) => 0 }
      )
    end

    it "returns the number of reservations per day when there are multiple users with reservations on various days" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      service = InsightsService.new(start_date: start_date, end_date: Date.new(2022, 1, 7))

      expect(service.all_reservations_per_day).to eq(
        { Date.new(2022, 1, 1) => 2,
          Date.new(2022, 1, 2) => 1,
          Date.new(2022, 1, 3) => 0,
          Date.new(2022, 1, 4) => 0,
          Date.new(2022, 1, 5) => 0,
          Date.new(2022, 1, 6) => 0,
          Date.new(2022, 1, 7) => 1, }
      )
    end
  end

  context ".number_of_reservations" do
    it "returns zero if there are no reservations" do
      expect(service.number_of_reservations).to be 0
    end

    it "returns one if there is a reservation" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(service.number_of_reservations).to be 1
    end

    it "returns the two if there are two reservations by different users on the same day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(service.number_of_reservations).to be 2
    end

    it "returns the two if there are two reservations by different users on different days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(service.number_of_reservations).to be 2
    end

    it "returns the number of reservations when there are multiple users with reservations on various days" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      service = InsightsService.new(start_date: start_date, end_date: Date.new(2022, 1, 7))

      expect(service.number_of_reservations).to be 4
    end
  end

  context ".average_reservations_per_day" do
    it "returns zero if there are no reservations" do
      expect(service.average_reservations_per_day).to be 0.0
    end

    it "returns the average if there is only one reservation on one day" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(service.average_reservations_per_day).to eq(0.3333333333333333)
    end

    it "returns the average if there are two reservations on one day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(service.average_reservations_per_day).to eq(0.6666666666666666)
    end

    it "returns the average if there are two reservations on consecutive days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(service.average_reservations_per_day).to eq(0.6666666666666666)
    end

    it "returns the average number of reservations across all days, ending with the last day with a reservation" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      service = InsightsService.new(start_date: start_date, end_date: Date.new(2022, 1, 7))

      expect(service.average_reservations_per_day).to eq(0.5714285714285714)
    end
  end

  context ".number_of_reservations_available" do
    it "returns the maximum capacity if there are no reservations" do
      expect(service.number_of_reservations_available).to be 6
    end

    it "returns the office capacity minus one if there is one reservation" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(service.number_of_reservations_available).to be 5
    end

    it "returns the office capacity minus two if there are two reservations on the same day by different users" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(service.number_of_reservations_available).to be 4
    end

    it "returns the total available spots across all days if there are two reservations on different days" +
       " by different users" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(service.number_of_reservations_available).to be 4
    end

    it "returns total available spots across all days" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      service = InsightsService.new(start_date: start_date, end_date: Date.new(2022, 1, 7))

      expect(service.number_of_reservations_available).to be 10
    end
  end
end
