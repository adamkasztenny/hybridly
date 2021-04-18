module ReservationHelper
  def format_reservation_count(count)
    if count == 1
      people_count = "1 person"
    else
      people_count = "#{count} people"
    end

    "#{people_count} in the office"
  end

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
