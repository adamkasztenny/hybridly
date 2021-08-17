module ReservationHelper
  def format_reservation_count(count)
    if count == 0
      people_count = "No people"
    elsif count == 1
      people_count = "1 person"
    else
      people_count = "#{count} people"
    end

    "#{people_count} in the office"
  end

  def icon_for(reservation)
    if reservation.verified?
      "&#10004;"
    else
      "&#10060;"
    end
  end
end
