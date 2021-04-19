default_user_email = ENV["DEFAULT_USER_EMAIL"]

unless default_user_email.nil? || default_user_email.empty?
  Rails.logger.info "Creating admin user with email #{default_user_email}"
  admin_user = User.create!(:email => default_user_email)
  admin_user.add_role(:admin)
else
  email = "hybridly@example.com"
  Rails.logger.info "Creating default admin user with email #{email}"
  admin_user = User.create!(:email => email)
  admin_user.add_role(:admin)
end

office_limit = 3
Rails.logger.info "Creating default reservation policy with office limit #{office_limit}"
ReservationPolicy.create!(user: admin_user, office_limit: office_limit)


Rails.logger.info "Creating other users"
violette = User.create!(:email => "violette@example.com")
nia = User.create!(:email => "nia@example.com")
caleb = User.create!(:email => "caleb@example.com")
keisha = User.create!(:email => "keisha@example.com")

