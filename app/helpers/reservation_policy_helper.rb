module ReservationPolicyHelper
  def format_reservation_policy_count(capacity)
    if capacity == 1
      capacity_count = "1 person is"
    else
      capacity_count = "#{capacity} people are"
    end

    "A total of #{capacity_count} allowed in the office"
  end
end
