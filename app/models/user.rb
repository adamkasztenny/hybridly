class User < ApplicationRecord
  rolify
  validates :email, presence: true, uniqueness: true
end
