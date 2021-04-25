class Workstation < ApplicationRecord
  include UserValidations

  enum workstation_type: [:desk, :meeting_room]

  belongs_to :user
  validates :capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :workstation_type, presence: true

  validate :user_must_be_an_admin
end
