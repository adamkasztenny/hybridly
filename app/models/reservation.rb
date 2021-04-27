class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :workspace, optional: true

  validates :date, presence: true

  validates_uniqueness_of :user_id, :scope => :date, :message => ->(object, data) do
    "has already reserved #{object.date}"
  end

  validate :does_not_exceed_office_capacity
  validate :does_not_exceed_workspace_capacity

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

  def does_not_exceed_office_capacity
    office_is_fully_booked = ReservationPolicy.current.capacity < reservations_for({ :date => date })

    if office_is_fully_booked
      errors.add(:capacity, "has been reached for #{date}")
    end
  end

  def does_not_exceed_workspace_capacity
    if workspace.nil?
      return
    end

    workspace_is_fully_booked = workspace.capacity < reservations_for({ :date => date, :workspace => workspace })

    if workspace_is_fully_booked
      errors.add(:workspace, "capacity has been reached for #{date}")
    end
  end

  def reservations_for(filters)
    number_of_reservations = Reservation.where(filters).count
    if self.new_record?
      number_of_reservations += 1
    end

    number_of_reservations
  end
end
