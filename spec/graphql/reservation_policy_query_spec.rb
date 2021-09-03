require 'rails_helper'

RSpec.describe "Reservation Policy Query" do
  before do
    Timecop.freeze(Time.parse('2021-02-01'))
  end

  after do
    Timecop.return
  end

  it "should return the current reservation policy" do
    create(:reservation_policy)

    result = executeReservationPolicyQuery

    expect(result).to eq({ "reservationPolicy" => { "capacity" => 1, "createdAt" => "2021-02-01T05:00:00Z" } })
  end

  private

  def executeReservationPolicyQuery
    query_string = "
    {
      reservationPolicy {
	capacity
        createdAt
      }
    }"
    result = HybridlySchema.execute(query_string)
    expect(result["errors"]).to be nil

    return result["data"]
  end
end
