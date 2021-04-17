require 'rails_helper'

RSpec.describe DashboardController do
  it 'includes Secured' do
    expect(DashboardController.ancestors.include? Secured).to be(true)
  end
end
