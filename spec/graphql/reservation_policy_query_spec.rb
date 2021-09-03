require 'rails_helper'
require 'graphql_helper'

RSpec.describe "Reservation Policy Query" do
  before do
    Timecop.freeze(Time.parse('2021-02-01'))
  end

  after do
    Timecop.return
  end

  it "should return the current reservation policy" do
    create(:reservation_policy)

    result = execute_reservation_policy_query

    expect(result).to eq({ "reservationPolicy" => { "capacity" => 1, "createdAt" => "2021-02-01T05:00:00Z" } })
  end

  private

  def execute_reservation_policy_query
    query_string = "
    {
      reservationPolicy {
	capacity
        createdAt
      }
    }"
    execute_query(query_string)
  end
end
