class ReservationPolicy < ApplicationRecord
  include UserValidations

  belongs_to :user
  validates :capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :user_must_be_an_admin

  def self.current
    ReservationPolicy.order(:created_at).last
  end

  def self.exceeds_capacity?(number_of_reservations)
    self.current.capacity < number_of_reservations
  end

  def spots_remaining(number_of_reservations)
    [0, capacity - number_of_reservations].max
  end

  private

  def user_must_be_an_admin
    model_user_must_be_an_admin(user)
  end
end
