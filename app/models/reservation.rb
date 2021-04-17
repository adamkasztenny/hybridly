class Reservation < ApplicationRecord
  belongs_to :user
  validates :date, presence: true

  validates_uniqueness_of :user_id, :scope => :date
end
