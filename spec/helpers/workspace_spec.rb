require 'rails_helper'

RSpec.describe WorkspaceHelper do
  let(:location) { "Some location" }
  let(:spots_remaining) { 2 }
  let(:workspace_type) { :desks }

  context "Spots remaining" do
    it "returns a message for no spots remaining" do
      message = format_workspace(location, workspace_type, 0)

      expect(message).to eq("Some location (Desks, No spots remaining)")
    end

    it "returns a message for one person in the workspace" do
      message = format_workspace(location, workspace_type, 1)

      expect(message).to eq("Some location (Desks, 1 spot remaining)")
    end

    it "returns a message for multiple people in the office" do
      message = format_workspace(location, workspace_type, 10)

      expect(message).to eq("Some location (Desks, 10 spots remaining)")
    end
  end

  context "Workspace type" do
    it "returns a message with for the desks workspace type" do
      message = format_workspace(location, :desks, spots_remaining)

      expect(message).to eq("Some location (Desks, 2 spots remaining)")
    end

    it "returns a message with for the meeting room workspace type" do
      message = format_workspace(location, :meeting_room, spots_remaining)

      expect(message).to eq("Some location (Meeting room, 2 spots remaining)")
    end
  end

  context "Location" do
    it "returns a message with the location" do
      message = format_workspace("HR", workspace_type, spots_remaining)

      expect(message).to eq("HR (Desks, 2 spots remaining)")
    end
  end
end
