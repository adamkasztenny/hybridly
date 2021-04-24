module UserValidations
  def user_must_be_an_admin
    errors.add(:user, "is not an admin") unless user.has_role?(:admin)
  end
end
