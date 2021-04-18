require 'rails_helper'

RSpec.describe ReservationPoliciesController do
  let(:admin_user) { User.create!(email: "hybridly-admin@example.com") }
  let(:office_limit) { 25 }

  before do
    admin_user.add_role(:admin)
    session[:user_id] = admin_user.id
  end

  it 'includes Secured' do
    expect(ReservationPoliciesController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new reservation policy successfully' do
    it 'saves the reservation policy' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(ReservationPolicy.first).not_to be nil
    end

    it 'saves the office limit on the reservation policy' do
      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(ReservationPolicy.first.office_limit).to eq(office_limit)
    end

    it 'saves the admin_user who created the reservation' do
      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(ReservationPolicy.first.user).to eq(admin_user)
    end

    it 'includes a successful flash message' do
      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(flash.notice).to eq("Policy updated to permit #{office_limit} people in the office")
    end

    it 'redirects to the dashboard' do
      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new reservation policy unsuccessfully' do
    it 'does not save the reservation policy if the office limit is empty' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :office_limit => "" } }

      expect(ReservationPolicy.first).to be nil
    end

    it 'does not save the reservation if the office limit is invalid' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :office_limit => "invalid" } }

      expect(ReservationPolicy.first).to be nil
    end

    it 'does not save the reservation if the user is not an admin' do
      regular_user = User.create!(email: "hybridly@example.com")
      session[:user_id] = regular_user.id

      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :office_limit => office_limit } }

      expect(ReservationPolicy.first).to be nil
    end
  end
end
