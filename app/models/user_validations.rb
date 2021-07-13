module UserValidations
  def model_user_must_be_an_admin(model_user)
    errors.add(:user, "is not an admin") unless model_user.has_role?(:admin)
  end
end
