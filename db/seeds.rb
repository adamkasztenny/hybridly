default_user_email = ENV["DEFAULT_USER_EMAIL"]

unless default_user_email.nil? || default_user_email.empty?
  Rails.logger.info "Creating admin user with email #{default_user_email}"
  admin_user = User.find_or_create_by!(:email => default_user_email)
  admin_user.add_role(:admin)
else
  email = "hybridly@example.com"
  Rails.logger.info "Creating default admin user with email #{email}"
  admin_user = User.find_or_create_by!(:email => email)
  admin_user.add_role(:admin)
end

office_limit = 3
Rails.logger.info "Creating default reservation policy with office limit #{office_limit}"
ReservationPolicy.find_or_create_by!(user: admin_user, office_limit: office_limit)

Rails.logger.info "Creating other users"
violette = User.find_or_create_by!(:email => "violette@example.com")
nia = User.find_or_create_by!(:email => "nia@example.com")
caleb = User.find_or_create_by!(:email => "caleb@example.com")
keisha = User.find_or_create_by!(:email => "keisha@example.com")

today = Date.today.next_occurring(:monday)
two_days_from_now = today + 2
four_days_from_now = today + 4
next_week = today.next_week(:monday)

Rails.logger.info "Creating reservations"
Reservation.find_or_create_by!(user: violette, date: today)
Reservation.find_or_create_by!(user: nia, date: today)
Reservation.find_or_create_by!(user: caleb, date: today)

Reservation.find_or_create_by!(user: nia, date: two_days_from_now)
Reservation.find_or_create_by!(user: keisha, date: two_days_from_now)

Reservation.find_or_create_by!(user: violette, date: four_days_from_now)
Reservation.find_or_create_by!(user: nia, date: four_days_from_now)
Reservation.find_or_create_by!(user: caleb, date: four_days_from_now)

Reservation.find_or_create_by!(user: violette, date: next_week)
