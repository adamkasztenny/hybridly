require 'rails_helper'

describe "View Reservations", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 3) }
  let!(:admin_user) { reservation_policy.user }

  let!(:engineering) { create(:workspace, location: "Engineering", user: admin_user) }
  let!(:board_room) {
    create(:workspace, location: "Board Room", workspace_type: :meeting_room, user: admin_user)
  }

  let!(:reservation) { create(:reservation, user: user, workspace: engineering, verified_by: admin_user) }
  let!(:second_reservation) {
    create(:reservation, user: create(:user, email: "second-hybridly@example.com"), workspace: board_room)
  }
  let!(:third_reservation) {
    create(:reservation, user: create(:user, email: "third-hybridly@example.com"), verified_by: admin_user)
  }

  before do
    Timecop.freeze(Time.parse('2022-01-01'))
  end

  after do
    Timecop.return
  end

  it "allows the user to click a day on the calendar and the see the number of people in the office" do
    login_as(user.email)

    click_on "3 people in the office"

    expect(page).to have_content "Reservations for 2022-01-01"
    expect(page).to have_content "3 people in the office:"
  end

  it "allows the user to click a day on the calendar and the see who has reserved a spot in the office" do
    login_as(user.email)

    click_on "3 people in the office"

    expect(page).to have_content "hybridly@example.com"
    expect(page).to have_content "second-hybridly@example.com"
    expect(page).to have_content "third-hybridly@example.com"
  end

  it "allows the user to click a day on the calendar and the see where people are working" do
    login_as(user.email)

    click_on "3 people in the office"

    expect(page).to have_content "hybridly@example.com (Working at a desk in Engineering)"
    expect(page).to have_content "second-hybridly@example.com (Working in Board Room)"
    expect(page).to have_content "third-hybridly@example.com"
  end

  it "shows who has a verified reservation" do
    login_as(user.email)

    click_on "3 people in the office"

    expect(page).to have_content "???hybridly@example.com"
    expect(page).to have_content "???second-hybridly@example.com"
    expect(page).to have_content "???third-hybridly@example.com"
  end
end
