require 'rails_helper'

describe "Insights", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 3) }

  let!(:reservation) { create(:reservation, user: user) }
  let!(:second_reservation) {
    create(:reservation, user: create(:user, email: "second-hybridly@example.com"))
  }
  let!(:third_reservation) {
    create(:reservation, user: create(:user, email: "third-hybridly@example.com"), date: Time.parse('2022-01-05'))
  }

  before do
    Timecop.freeze(Time.parse('2022-01-01'))
    Capybara.ignore_hidden_elements = false
  end

  after do
    Timecop.return
    Capybara.ignore_hidden_elements = true
  end

  it "allows the user to view a line chart with the number of reservations per day" do
    login_as(user.email)

    click_on "Insights"

    expect(page).to have_content "Reservations Per Day"

    expect(page).to have_content('new Chartkick["LineChart"]')

    expect(page).to have_content "2022-01-01"
    expect(page).to have_content "2022-01-02"
    expect(page).to have_content "2022-01-03"
    expect(page).to have_content "2022-01-04"
    expect(page).to have_content "2022-01-05"
  end

  it "allows the user to view the average number of reservations per day" do
    login_as(user.email)

    click_on "Insights"

    expect(page).to have_content "Average Reservations Per Day"
    expect(page).to have_content "0.60"
  end

  it "allows the user to view a pie chart with the total number of reservations and the total number of" +
     " reservations available" do
    pending

    login_as(user.email)

    click_on "Insights"

    expect(page).to have_content "Reservations Used vs Available"

    expect(page).to have_content('new Chartkick["Pie Chart"]')
    expect(page).to have_content('Reservations Used: 3')
    expect(page).to have_content('Reservations Available: 15')
  end
end
