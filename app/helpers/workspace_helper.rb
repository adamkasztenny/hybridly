module WorkspaceHelper
  def format_workspace_location(workspace)
    if workspace.nil?
      ""
    elsif workspace.desks?
      "(Working at a desk in #{workspace.location})"
    else
      "(Working in #{workspace.location})"
    end
  end
end
