class Workstation < ApplicationRecord
  include UserValidations

  belongs_to :user
  validates :capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true

  validate :user_must_be_an_admin
end
