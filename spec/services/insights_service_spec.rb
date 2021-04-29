require 'rails_helper'

RSpec.describe InsightsService do
  let!(:second_user) { create(:user, email: "hybridly-second@example.com") }

  before do
    create(:reservation_policy, capacity: 2)
  end

  context ".all_reservations_per_day" do
    it "returns an empty hash if there are no reservations" do
      expect(InsightsService.all_reservations_per_day).to be {}
    end

    it "returns a single date with a count of one if a user has made a reservation" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(InsightsService.all_reservations_per_day).to be
      { '2022-01-01' => 1 }
    end

    it "returns a single date with a count of two if two users have made a reservation on the same day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(InsightsService.all_reservations_per_day).to be
      { '2022-01-01' => 2 }
    end

    it "returns a two dates with a count of one if two users have made a reservation on the different days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(InsightsService.all_reservations_per_day).to be
      { '2022-01-01' => 1, '2022-01-02' => 1 }
    end

    it "returns the number of reservations per day when there are multiple users with reservations on various days" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      expect(InsightsService.all_reservations_per_day).to be
      { '2022-01-01' => 2,
        '2022-01-02' => 1,
        '2022-01-03' => 0,
        '2022-01-04' => 0,
        '2022-01-05' => 0,
        '2022-01-06' => 0,
        '2022-01-07' => 1, }
    end
  end

  context ".number_of_reservations" do
    it "returns zero if there are no reservations" do
      expect(InsightsService.number_of_reservations).to be 0
    end

    it "returns one if there is a reservation" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(InsightsService.number_of_reservations).to be 1
    end

    it "returns the two if there are two reservations by different users on the same day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(InsightsService.number_of_reservations).to be 2
    end

    it "returns the two if there are two reservations by different users on different days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(InsightsService.number_of_reservations).to be 2
    end

    it "returns the number of reservations when there are multiple users with reservations on various days" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      expect(InsightsService.number_of_reservations).to be 4
    end
  end

  context ".average_reservations_per_day" do
    it "returns zero if there are no reservations" do
      expect(InsightsService.average_reservations_per_day).to be 0
    end

    it "returns one if there is only one reservation on one day" do
      create(:reservation, date: Date.new(2022, 1, 1))

      expect(InsightsService.average_reservations_per_day).to eq(1.0)
    end

    it "returns two if there are two reservations on one day" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))

      expect(InsightsService.average_reservations_per_day).to eq(2.0)
    end

    it "returns one if there are two reservations on consecutive days" do
      create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 2))

      expect(InsightsService.average_reservations_per_day).to eq(1.0)
    end

    it "returns the average number of reservations across all days, ending with the last day with a reservation" do
      first_reservation = create(:reservation, date: Date.new(2022, 1, 1))
      create(:reservation, user: first_reservation.user, date: Date.new(2022, 1, 2))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 1))
      create(:reservation, user: second_user, date: Date.new(2022, 1, 7))

      expect(InsightsService.average_reservations_per_day).to eq(0.5714285714285714)
    end
  end
end
