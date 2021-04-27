class Workspace < ApplicationRecord
  include UserValidations

  has_many :reservations

  enum workspace_type: [:desks, :meeting_room]

  belongs_to :user
  validates :capacity, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :location, presence: true
  validates :workspace_type, presence: true
  validates_uniqueness_of :location, :scope => :workspace_type, :message => ->(object, data) do
    "with type #{object.workspace_type} already exists"
  end

  validate :user_must_be_an_admin

  def exceeds_capacity?(number_of_reservations)
    capacity < number_of_reservations
  end
end
