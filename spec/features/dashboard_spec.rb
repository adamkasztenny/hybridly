require 'rails_helper'

describe "Dashboard", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, office_limit: 3) }

  before do
    Timecop.freeze(Time.parse('2022-01-01'))
  end

  after do
    Timecop.return
  end

  it "displays a monthly calendar set to the current month" do
    login_as(user.email)

    expect(page).to have_content "January 2022"
    expect(page).to have_content "2022-01-01"
    expect(page).to have_content "2022-01-31"
  end

  it "displays the days of the week" do
    login_as(user.email)

    expect(page).to have_content "Mon"
    expect(page).to have_content "Tue"
    expect(page).to have_content "Wed"
    expect(page).to have_content "Thu"
    expect(page).to have_content "Fri"
    expect(page).to have_content "Sat"
    expect(page).to have_content "Sun"
  end

  it "displays how many people are in the office on a given day" do
    create(:reservation, user: user)
    create(:reservation, user: create(:user, email: 'hybridly-other@example.com'))
    create(:reservation, date: Date.parse('2022-01-15'), user: user)

    login_as(user.email)

    expect(page).to have_content "2022-01-01\n2 people in the office"
    expect(page).to have_content "2022-01-15\n1 person in the office"
  end

  it "displays how many people are allowed to be in the office" do
    login_as(user.email)

    expect(page).to have_content "A total of 3 people are allowed in the office"
  end

  it "displays how many spots are left in the office for the current dasy" do
    create(:reservation, user: user)

    login_as(user.email)

    expect(page).to have_content "2 spots remaining for today"
  end
end
