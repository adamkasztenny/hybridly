require 'rails_helper'

RSpec.describe ReservationPoliciesController do
  let!(:admin_user) { create(:admin_user) }
  let(:capacity) { 25 }

  before do
    session[:user_id] = admin_user.id
  end

  it 'includes Secured' do
    expect(ReservationPoliciesController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new reservation policy successfully' do
    it 'saves the reservation policy' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(ReservationPolicy.first).not_to be nil
    end

    it 'saves the capacity on the reservation policy' do
      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(ReservationPolicy.first.capacity).to eq(capacity)
    end

    it 'saves the admin_user who created the reservation policy' do
      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(ReservationPolicy.first.user).to eq(admin_user)
    end

    it 'includes a successful flash message' do
      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(flash.notice).to eq("Policy updated to permit #{capacity} people in the office")
    end

    it 'redirects to the dashboard' do
      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new reservation policy unsuccessfully' do
    it 'does not save the reservation policy if the capacity is empty' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :capacity => "" } }

      expect(ReservationPolicy.first).to be nil
    end

    it 'does not save the reservation policy if the capacity is invalid' do
      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :capacity => "invalid" } }

      expect(ReservationPolicy.first).to be nil
    end

    it 'does not save the reservation policy if the user is not an admin' do
      regular_user = create(:user)
      session[:user_id] = regular_user.id

      expect(ReservationPolicy.first).to be nil

      post :create, :params => { :reservation_policy => { :capacity => capacity } }

      expect(ReservationPolicy.first).to be nil
    end
  end
end
