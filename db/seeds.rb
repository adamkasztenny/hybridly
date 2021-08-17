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

capacity = 3
Rails.logger.info "Creating default reservation policy with capacity #{capacity}"
ReservationPolicy.find_or_create_by!(user: admin_user, capacity: capacity)

Rails.logger.info "Creating workspaces"
engineering = Workspace.find_or_create_by!(user: admin_user, location: "Engineering", workspace_type: :desks,
                                           capacity: 5)
hr = Workspace.find_or_create_by!(user: admin_user, location: "HR", workspace_type: :desks, capacity: 5)
sales = Workspace.find_or_create_by!(user: admin_user, location: "Sales", workspace_type: :desks, capacity: 10)
board_room = Workspace.find_or_create_by!(user: admin_user, location: "Board Room", workspace_type: :meeting_room,
                                          capacity: 5)

Rails.logger.info "Creating other users"
violette = User.find_or_create_by!(:email => "violette@example.com")
nia = User.find_or_create_by!(:email => "nia@example.com")
caleb = User.find_or_create_by!(:email => "caleb@example.com")
keisha = User.find_or_create_by!(:email => "keisha@example.com")

Rails.logger.info "Creating reservations"

start_date = 3.months.ago.to_date
six_months_in_weeks = 6 * 4

(0..six_months_in_weeks).map do |week|
  today = start_date.next_occurring(:monday) + week.weeks
  mid_week = today + rand(1..2)
  later_this_week = today + rand(3..4)
  next_week = today.next_week(:monday) + rand(1..2)

  Reservation.find_or_create_by!(user: violette, date: today, workspace: board_room,
                                 verification_code: SecureRandom.uuid, verified_by: admin_user)
  Reservation.find_or_create_by!(user: nia, date: today, workspace: board_room, verification_code: SecureRandom.uuid)
  Reservation.find_or_create_by!(user: caleb, date: today, workspace: board_room, verification_code: SecureRandom.uuid,
                                 verified_by: admin_user)

  Reservation.find_or_create_by!(user: nia, date: mid_week, verification_code: SecureRandom.uuid,
                                 verified_by: admin_user)
  Reservation.find_or_create_by!(user: keisha, date: mid_week, workspace: engineering,
                                 verification_code: SecureRandom.uuid)

  Reservation.find_or_create_by!(user: violette, date: later_this_week, workspace: hr,
                                 verification_code: SecureRandom.uuid)
  Reservation.find_or_create_by!(user: nia, date: later_this_week, workspace: hr, verification_code: SecureRandom.uuid)
  Reservation.find_or_create_by!(user: caleb, date: later_this_week, workspace: sales,
                                 verification_code: SecureRandom.uuid)

  Reservation.find_or_create_by!(user: violette, date: next_week, verification_code: SecureRandom.uuid,
                                 verified_by: admin_user)
end
