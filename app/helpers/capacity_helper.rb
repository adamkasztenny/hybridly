module CapacityHelper
  def format_spots_remaining(spots_remaining)
    if spots_remaining == 0
      spots_remaining_count = "No spots"
    elsif spots_remaining == 1
      spots_remaining_count = "1 spot"
    else
      spots_remaining_count = "#{spots_remaining} spots"
    end

    "#{spots_remaining_count} remaining for today"
  end
end
