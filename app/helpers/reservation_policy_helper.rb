module ReservationPolicyHelper
  def format_reservation_policy_count(office_limit)
    if office_limit == 1
      office_limit_count = "1 person is"
    else
      office_limit_count = "#{office_limit} people are"
    end

    "A total of #{office_limit_count} allowed in the office"
  end
end
