class Reservation < ApplicationRecord
  belongs_to :user
  belongs_to :workspace, optional: true

  validates :date, presence: true
  validates :verification_code, presence: true

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

  def self.verify(verification_code)
    reservation = Reservation.find_by(verification_code: verification_code)
    if reservation.nil?
      return false
    end

    reservation
  end

  private

  def does_not_exceed_office_capacity
    number_of_reservations = reservations_for({ :date => date })

    if ReservationPolicy.exceeds_capacity?(number_of_reservations)
      errors.add(:capacity, "has been reached for #{date}")
    end
  end

  def does_not_exceed_workspace_capacity
    if workspace.nil?
      return
    end

    number_of_reservations = reservations_for({ :date => date, :workspace => workspace })

    if workspace.exceeds_capacity?(number_of_reservations)
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
