require 'rails_helper'

describe "Logging in", type: :feature do
  let(:email) { 'user@example.com' }

  before :each do
    User.create!(email: email)
  end

  it "authenticates the user" do
    OmniAuth.config.mock_auth[:auth0] = { 'extra' => { 'raw_info' => { :name => email } } }

    visit '/'

    click_button 'Login'

    expect(page).to have_content "Welcome #{email}!"
  end

  it "shows a failure page if the user does not exist" do
    OmniAuth.config.mock_auth[:auth0] = { 'extra' => { 'raw_info' => { :name => "does-not-exist@example.com" } } }

    visit '/'

    click_button 'Login'

    expect(page).not_to have_content "Welcome #{email}!"
    expect(page).to have_content "Login failed"
  end
end
