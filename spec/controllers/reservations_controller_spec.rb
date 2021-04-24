require 'rails_helper'

RSpec.describe ReservationsController do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2) }

  before do
    session[:user_id] = user.id
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
