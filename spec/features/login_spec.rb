require 'rails_helper'

describe "Logging in", type: :feature do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy) }

  it "authenticates the user" do
    login_as(user.email)

    expect(page).to have_content user.email
  end

  it "shows a failure page if the user does not exist" do
    non_existent_email = "does-not-exist@example.com"
    login_as(non_existent_email)

    expect(page).not_to have_content "Welcome #{user.email}!"
    expect(page).not_to have_content "Welcome #{non_existent_email}!"
    expect(page).to have_content "Login failed"
  end
end
