require 'rails_helper'

RSpec.describe "Workspaces Query" do
  it "should return an empty list if there are no workspaces" do
    result = executeWorkspacesQuery

    expect(result).to eq({ "workspaces" => [] })
  end

  it "should return all workspaces if there are some" do
    workspace = create(:workspace, workspace_type: :desks)
    create(:workspace, location: "Office", user: workspace.user, workspace_type: :meeting_room)

    result = executeWorkspacesQuery

    expect(result).to eq({ "workspaces" => [
                           { "capacity" => 1, "id" => "1", "location" => "Engineering",
                             "workspaceType" => "desks" },
                           { "capacity" => 1, "id" => "2", "location" => "Office", "workspaceType" => "meeting_room" }
                         ] })
  end

  private

  def executeWorkspacesQuery
    query_string = "
    {
      workspaces {
	id
	location
	capacity
        workspaceType
      }
    }"
    result = HybridlySchema.execute(query_string)
    expect(result["errors"]).to be nil

    return result["data"]
  end
end
