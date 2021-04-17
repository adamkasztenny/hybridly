class User < ApplicationRecord
  rolify
  validates :email, presence: true, uniqueness: true

  after_create :assign_default_role

  private

  def assign_default_role
    self.add_role(:employee) if self.roles.blank?
  end
end
