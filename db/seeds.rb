default_user_email = ENV["DEFAULT_USER_EMAIL"]

unless default_user_email.nil? || default_user_email.empty?
  Rails.logger.info "Creating user with email #{default_user_email}"
  User.create!(:email => default_user_email)

  Rails.logger.info "Number of users in database: #{User.count}"
end
