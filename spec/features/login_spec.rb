require 'rails_helper'

describe "Logging in", type: :feature do
  let(:valid_email) { 'user@example.com' }

  before :each do
    User.create!(email: valid_email)
  end

  it "authenticates the user" do
    authenticate(valid_email)

    visit '/'

    click_button 'Login'

    expect(page).to have_content "Welcome #{valid_email}!"
  end

  it "shows a failure page if the user does not exist" do
    non_existent_email = "does-not-exist@example.com"
    authenticate(non_existent_email)

    visit '/'

    click_button 'Login'

    expect(page).not_to have_content "Welcome #{valid_email}!"
    expect(page).not_to have_content "Welcome #{non_existent_email}!"
    expect(page).to have_content "Login failed"
  end
end
