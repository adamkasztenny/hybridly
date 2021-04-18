class ReservationPolicy < ApplicationRecord
  belongs_to :user
  validates :office_limit, presence: true, numericality: { greater_than_or_equal_to: 0 }

  validate :user_must_be_an_admin

  def self.current
    ReservationPolicy.order(:created_at).last
  end

  private

  def user_must_be_an_admin
    errors.add(:user, "is not an admin") unless user.has_role?(:admin)
  end
end
