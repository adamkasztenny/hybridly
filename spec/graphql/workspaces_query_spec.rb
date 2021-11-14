require 'rails_helper'
require 'graphql_helper'

RSpec.describe "Workspaces Query" do
  it "should return an empty list if there are no workspaces" do
    result = execute_workspaces_query

    expect(result).to eq({ "workspaces" => [] })
  end

  it "should return all workspaces if there are some" do
    workspace = create(:workspace, workspace_type: :desks)
    create(:workspace, location: "Office", user: workspace.user, workspace_type: :meeting_room)

    result = execute_workspaces_query

    expect(result).to eq({ "workspaces" => [
                           { "capacity" => 1, "location" => "Engineering",
                             "workspaceType" => "desks" },
                           { "capacity" => 1, "location" => "Office", "workspaceType" => "meeting_room" }
                         ] })
  end

  private

  def execute_workspaces_query
    query_string = "
    {
      workspaces {
        location
        capacity
        workspaceType
      }
    }"
    return execute_query(query_string)
  end
end
