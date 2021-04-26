module WorkspaceHelper
  include ReservationHelper

  def format_workspace(location, workspace_type, spots_remaining)
    "#{location} (#{workspace_type.to_s.humanize}, #{format_spots_remaining(spots_remaining, false)})"
  end
end
