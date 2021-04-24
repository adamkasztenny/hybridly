class Workstation < ApplicationRecord
  belongs_to :user
  validates :capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true

  validate :user_must_be_an_admin

  private

  def user_must_be_an_admin
    errors.add(:user, "is not an admin") unless user.has_role?(:admin)
  end
end
