require 'rails_helper'
require 'graphql_helper'

RSpec.describe "Reservations Query" do
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2) }

  it "should return an empty array if there are no reservations for that day" do
    result = execute_reservations_per_day_query

    expect(result).to eq({ "reservations" => [] })
  end

  it "should return each reservations for that day without workspaces" do
    first_reservation = create(:reservation, date: Date.new(2022, 1, 2))
    create(:reservation, date: Date.new(2022, 1, 3), user: first_reservation.user)
    create(:reservation, date: Date.new(2022, 1, 3), user: create(:user, email: "other-user@example.com"))

    result = execute_reservations_per_day_query

    expect(result).to eq({ "reservations" => [{ "date" => "2022-01-03",
                                                "user" => first_reservation.user.email, "workspace" => nil },
                                              { "date" => "2022-01-03", "user" => "other-user@example.com",
                                                "workspace" => nil }] })
  end

  it "should return each reservations for that day with workspaces" do
    first_workspace = create(:workspace, user: reservation_policy.user)
    second_workspace = create(:workspace, location: "Server Closet", user: reservation_policy.user, capacity: 2)

    first_reservation = create(:reservation, date: Date.new(2022, 1, 2), workspace: first_workspace)
    create(:reservation, date: Date.new(2022, 1, 3), user: first_reservation.user, workspace: first_workspace)
    create(:reservation, date: Date.new(2022, 1, 3), user: create(:user, email: "other-user@example.com"),
                         workspace: second_workspace)

    result = execute_reservations_per_day_query

    expect(result).to eq({ "reservations" => [{ "date" => "2022-01-03", "user" => first_reservation.user.email,
                                                "workspace" => { "location" => "Engineering",
                                                                 "capacity" => 1, "workspaceType" => "desks" } },
                                              { "date" => "2022-01-03", "user" => "other-user@example.com",
                                                "workspace" => { "location" => "Server Closet",
                                                                 "capacity" => 2, "workspaceType" => "desks" } }] })
  end

  private

  def execute_reservations_per_day_query
    query_string = '
    {
      reservations(date: "2022-01-03") {
        date
        user
        workspace {
          location
          capacity
          workspaceType
        }
      }
    }'
    execute_query(query_string)
  end
end
