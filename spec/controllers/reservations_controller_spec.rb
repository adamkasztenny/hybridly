require 'rails_helper'

RSpec.describe ReservationsController do
  let!(:user) { create(:user) }
  let!(:reservation_policy) { create(:reservation_policy, capacity: 2) }
  let(:date) { '2023-01-01' }

  before do
    session[:user_id] = user.id
  end

  it 'includes Secured' do
    expect(ReservationsController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new reservation successfully' do
    let(:workspace) { create(:workspace, user: reservation_policy.user) }

    it 'saves the reservation' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(Reservation.first).not_to be nil
    end

    it 'saves the date on the reservation' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(Reservation.first.date).to eq(Date.parse(date))
    end

    it 'saves the user who created the reservation' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(Reservation.first.user).to eq(user)
    end

    it 'does not saves the workspace if no ID is provided' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(Reservation.first.workspace).to be nil
    end

    it 'does saves the workspace if its ID is provided' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => workspace.id } }

      expect(Reservation.first.workspace).to eq(workspace)
    end

    it 'includes a successful flash message' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(flash.notice).to eq("Reservation for #{date} successful!")
    end

    it 'redirects to the dashboard' do
      post :create, :params => { :reservation => { :date => date, :workspace_id => "" } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new reservation unsuccessfully' do
    it 'does not save the reservation if the date is empty' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => "", :workspace_id => "" } }

      expect(Reservation.first).to be nil
    end

    it 'does not save the reservation if the date is invalid' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => "invalid", :workspace_id => "" } }

      expect(Reservation.first).to be nil
    end

    it 'does not save the reservation if the workspace ID is invalid' do
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => date, :workspace_id => "invalid" } }

      expect(Reservation.first).to be nil
    end

    it 'does not save the reservation if the workspace ID does not exist' do
      non_existant_workspace_id = 5
      expect(Reservation.first).to be nil

      post :create, :params => { :reservation => { :date => date, :workspace_id => non_existant_workspace_id } }

      expect(Reservation.first).to be nil
    end
  end
end
