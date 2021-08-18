require 'rails_helper'

RSpec.describe GraphqlController do
  let!(:user) { create(:user) }

  before do
    session[:user_id] = user.id
  end

  it 'includes Secured' do
    expect(GraphqlController.ancestors.include? Secured).to be(true)
  end

  it 'can return the GraphQL schema' do
    post :execute, :params => { :query => GraphQL::Introspection::INTROSPECTION_QUERY }

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body)
    expect(json_response["data"]).not_to be_empty
    expect(json_response["errors"]).to be nil
  end

  it 'returns an error if the query is invalid' do
    post :execute, :params => { :query => 'invalid GraphQL query' }

    expect(response).to have_http_status(:ok)

    json_response = JSON.parse(response.body)
    expect(json_response["data"]).to be nil
    expect(json_response["errors"]).not_to be_empty
  end
end
