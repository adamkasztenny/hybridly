class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :workspace, optional: true

  validates :date, presence: true

  validates_uniqueness_of :user_id, :scope => :date, :message => ->(object, data) do
    "has already reserved #{object.date}"
  end

  validate :does_not_exceed_capacity

  def self.reservations_per_day
    Reservation.group(:date).count(:date)
  end

  def self.spots_remaining_for_today
    used_spots = Reservation.where(date: Date.today).count
    capacity = ReservationPolicy.current.capacity
    capacity - used_spots
  end

  def self.for_date(date)
    Reservation.where(date: date)
  end

  private

  def does_not_exceed_capacity
    office_is_fully_booked = ReservationPolicy.current.capacity < reservations_for(date)

    if office_is_fully_booked
      errors.add(:capacity, "has been reached for #{date}")
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
