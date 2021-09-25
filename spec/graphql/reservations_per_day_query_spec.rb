require 'rails_helper'
require 'graphql_helper'

RSpec.describe "Reservations Per Day Query" do
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2) }

  it "should return an empty array if there are no reservations" do
    result = execute_reservations_per_day_query

    expect(result).to eq({ "reservationsPerDay" => [] })
  end

  it "should return the number of reservations per day" do
    first_reservation = create(:reservation, date: Date.new(2022, 1, 2))
    create(:reservation, date: Date.new(2022, 1, 3), user: first_reservation.user)
    create(:reservation, date: Date.new(2022, 1, 3), user: create(:user, email: "other-user@example.com"))

    result = execute_reservations_per_day_query

    expect(result).to eq({ "reservationsPerDay" => [{ "date" => "2022-01-02", "numberOfReservations" => 1 },
                                                    { "date" => "2022-01-03", "numberOfReservations" => 2 }] })
  end

  private

  def execute_reservations_per_day_query
    query_string = "
    {
      reservationsPerDay {
        date
        numberOfReservations
      }
    }"
    execute_query(query_string)
  end
end
