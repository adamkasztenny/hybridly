require 'rails_helper'

RSpec.describe MetricsController do
  it 'includes Secured' do
    expect(MetricsController.ancestors.include? Secured).to be(true)
  end
end
