require 'rails_helper'

RSpec.describe WorkstationsController do
  let!(:admin_user) { create(:admin_user) }
  let(:location) { "Sales" }
  let(:capacity) { 25 }
  let(:workstation_type) { "desk" }

  before do
    session[:user_id] = admin_user.id
  end

  it 'includes Secured' do
    expect(WorkstationsController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new workstation successfully' do
    it 'saves the workstation' do
      expect(Workstation.first).to be nil

      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first).not_to be nil
    end

    it 'saves the capacity on the workstation' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first.capacity).to eq(capacity)
    end

    it 'saves the location on the workstation' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first.location).to eq(location)
    end

    it 'saves the workstation type on the workstation' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first.workstation_type).to eq("desk")
      expect(Workstation.first.desk?).to be true
    end

    it 'saves the admin_user who created the workstation' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first.user).to eq(admin_user)
    end

    it 'includes a successful flash message' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(flash.notice).to eq("#{location} workstation created with a capacity of #{capacity} people")
    end

    it 'redirects to the dashboard' do
      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new workstation unsuccessfully' do
    it 'does not save the workstation if the location is empty' do
      expect(Workstation.first).to be nil

      post :create,
           :params => { :workstation => { :location => "", :workstation_type => workstation_type,
                                          :capacity => capacity } }

      expect(Workstation.first).to be nil
    end

    it 'does not save the workstation if the capacity is empty' do
      expect(Workstation.first).to be nil

      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => "" } }

      expect(Workstation.first).to be nil
    end

    it 'does not save the workstation if the capacity is invalid' do
      expect(Workstation.first).to be nil

      post :create,
           :params => { :workstation => { :location => location, :workstation_type => workstation_type,
                                          :capacity => "invalid" } }

      expect(Workstation.first).to be nil
    end

    it 'does not save the workstation if the workstation type is empty' do
      expect(Workstation.first).to be nil

      post :create, :params => { :workstation => { :location => location, :capacity => capacity } }

      expect(Workstation.first).to be nil
    end

    it 'does not save the workstation if the workstation type is invalid' do
      expect(Workstation.first).to be nil

      post :create,
           :params => { :workstation => { :location => location, :workstation_type => "invalid",
                                          :capacity => capacity } }

      expect(Workstation.first).to be nil
    end

    it 'does not save the workstation if the user is not an admin' do
      regular_user = create(:user)
      session[:user_id] = regular_user.id

      expect(Workstation.first).to be nil

      post :create, :params => { :workstation => { :location => location, :capacity => capacity } }

      expect(Workstation.first).to be nil
    end
  end
end
