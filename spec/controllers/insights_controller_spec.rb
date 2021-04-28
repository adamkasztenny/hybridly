require 'rails_helper'

RSpec.describe InsightsController do
  it 'includes Secured' do
    expect(InsightsController.ancestors.include? Secured).to be(true)
  end
end
