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
  let!(:reservation_for_last_month) { create(:reservation, user: user, date: Time.parse('2021-12-30')) }

  before do
    Timecop.freeze(Time.parse('2022-01-01'))
    Capybara.ignore_hidden_elements = false

    login_as(user.email)

    click_on "Insights"
  end

  after do
    Timecop.return
    Capybara.ignore_hidden_elements = true
  end

  context "with a date filter" do
    before do
      fill_in 'start_date', :with => '2022-01-01'
      fill_in 'end_date', :with => '2022-01-31'
      click_on "View"
    end

    it "allows the user to view a line chart with the number of reservations per day" do
      expect(page).to have_content "Reservations Per Day"

      expect(page).to have_content('new Chartkick["LineChart"]')

      expect(page).to have_content '"2022-01-01",2'
      expect(page).to have_content '"2022-01-02",0'
      expect(page).to have_content '"2022-01-03",0'
      expect(page).to have_content '"2022-01-04",0'
      expect(page).to have_content '"2022-01-05",1'
      expect(page).to have_content '"2022-01-15",0'
      expect(page).to have_content '"2022-01-31",0'
    end

    it "allows the user to view the average number of reservations per day" do
      expect(page).to have_content "Average Reservations Per Day"
      expect(page).to have_content "0.10"
    end

    it "allows the user to view a pie chart with the total number of reservations and the total number of" +
       " reservations available" do
      pending

      expect(page).to have_content "Reservations Used vs Available"

      expect(page).to have_content('new Chartkick["PieChart"]')
      expect(page).to have_content('"Used",3')
      expect(page).to have_content('"Available",90')
    end
  end

  context "without a date filter" do
    it "allows the user to view a line chart with the number of reservations per day for the last month" do
      expect(page).to have_content "Reservations Per Day"

      expect(page).to have_content('new Chartkick["LineChart"]')

      expect(page).to have_content '"2021-12-01",0'
      expect(page).to have_content '"2021-12-30",1'
      expect(page).to have_content '"2022-01-01",2'
    end

    it "allows the user to view the average number of reservations per day for the last month" do
      expect(page).to have_content "Average Reservations Per Day"
      expect(page).to have_content "0.09"
    end

    it "allows the user to view a pie chart with the total number of reservations and the total number of" +
       " reservations available for the last month" do
      pending

      expect(page).to have_content "Reservations Used vs Available"

      expect(page).to have_content('new Chartkick["PieChart"]')
      expect(page).to have_content('"Used",3')
      expect(page).to have_content('"Available",93')
    end
  end
end
