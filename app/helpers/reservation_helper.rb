module ReservationHelper
  def format_reservation_count(count)
    if count == 1
      people_count = "1 person"
    else
      people_count = "#{count} people"
    end

    "#{people_count} in the office"
  end
end
