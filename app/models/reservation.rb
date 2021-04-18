class Reservation < ApplicationRecord
  belongs_to :user
  validates :date, presence: true

  validates_uniqueness_of :user_id, :scope => :date, :message => ->(object, data) do
    "has already reserved #{object.date}"
  end

  validate :does_not_exceed_office_limit

  private

  def does_not_exceed_office_limit
    office_is_fully_booked = ReservationPolicy.current.office_limit < reservations_for(date)

    if office_is_fully_booked
      errors.add(:office_limit, "has been reached for #{date}")
    end
  end

  def reservations_for(date)
    number_of_reservations = Reservation.where(date: date).count
    if self.new_record?
      number_of_reservations += 1
    end

    number_of_reservations
  end
end
