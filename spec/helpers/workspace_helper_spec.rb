require 'rails_helper'

RSpec.describe WorkspaceHelper do
  context "User's location" do
    it "returns an empty string when there is no workspace" do
      message = format_workspace_location(nil)

      expect(message).to eq("")
    end

    it "returns a message for when the user is working at a desk" do
      workspace = create(:workspace, workspace_type: :desks)

      message = format_workspace_location(workspace)

      expect(message).to eq("(Working at a desk in Engineering)")
    end

    it "returns a message for when the user is working in a meeting room" do
      workspace = create(:workspace, workspace_type: :meeting_room)

      message = format_workspace_location(workspace)

      expect(message).to eq("(Working in Engineering)")
    end
  end
end
