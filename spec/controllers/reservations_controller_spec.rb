require 'rails_helper'

RSpec.describe ReservationsController do
  let(:user) { User.create!(email: "hybridly@example.com") }

  before do
    session[:user_id] = user.id

    admin_user = User.create!(email: "hybridly-admin@example.com")
    admin_user.add_role(:admin)
    ReservationPolicy.create!(office_limit: 2, user: admin_user)
  end

  it 'includes Secured' do
    expect(ReservationsController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new reservation successfully' do
    let(:date) { '2023-01-01' }

    it 'saves the reservation' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => date } }

      expect(Reservation.first).not_to be nil
    end

    it 'saves the date on the reservation' do
      post :create, :params => { :reservation => { :date => date } }

      expect(Reservation.first.date).to eq(Date.parse(date))
    end

    it 'saves the user who created the reservation' do
      post :create, :params => { :reservation => { :date => date } }

      expect(Reservation.first.user).to eq(user)
    end

    it 'includes a successful flash message' do
      post :create, :params => { :reservation => { :date => date } }

      expect(flash.notice).to eq("Reservation for #{date} successful!")
    end

    it 'redirects to the dashboard' do
      post :create, :params => { :reservation => { :date => date } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new reservation unsuccessfully' do
    it 'does not save the reservation if the date is empty' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => "" } }

      expect(Reservation.first).to be nil
    end

    it 'does not save the reservation if the date is invalid' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => "invalid" } }

      expect(Reservation.first).to be nil
    end
  end
end
