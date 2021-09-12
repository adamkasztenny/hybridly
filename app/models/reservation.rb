class Reservation < ApplicationRecord
  include UserValidations

  belongs_to :user
  belongs_to :verified_by, class_name: 'User', optional: true
  belongs_to :workspace, optional: true

  validates :date, presence: true

  validates :verification_code, presence: true
  validate :verified_by_an_admin

  validates_uniqueness_of :user_id, :scope => :date, :message => ->(object, data) do
    "has already reserved #{object.date}"
  end

  validate :does_not_exceed_office_capacity
  validate :does_not_exceed_workspace_capacity

  def verified?
    !verified_by.nil?
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

  def verified_by_an_admin
    if verified_by.nil?
      return
    end

    model_user_must_be_an_admin(verified_by)

    if user.id == verified_by.id
      errors.add(:verified_by, "cannot be the same user")
    end
  end
end
