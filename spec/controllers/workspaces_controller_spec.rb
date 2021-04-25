require 'rails_helper'

RSpec.describe WorkspacesController do
  let!(:admin_user) { create(:admin_user) }
  let(:location) { "Sales" }
  let(:capacity) { 25 }
  let(:workspace_type) { "desk" }

  before do
    session[:user_id] = admin_user.id
  end

  it 'includes Secured' do
    expect(WorkspacesController.ancestors.include? Secured).to be(true)
  end

  context 'creating a new workspace successfully' do
    it 'saves the workspace' do
      expect(Workspace.first).to be nil

      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first).not_to be nil
    end

    it 'saves the capacity on the workspace' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first.capacity).to eq(capacity)
    end

    it 'saves the location on the workspace' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first.location).to eq(location)
    end

    it 'saves the workspace type on the workspace' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first.workspace_type).to eq("desk")
      expect(Workspace.first.desk?).to be true
    end

    it 'saves the admin_user who created the workspace' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first.user).to eq(admin_user)
    end

    it 'includes a successful flash message' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(flash.notice).to eq("#{location} workspace created with a capacity of #{capacity} people")
    end

    it 'redirects to the dashboard' do
      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(response).to redirect_to('/dashboard')
    end
  end

  context 'creating a new workspace unsuccessfully' do
    it 'does not save the workspace if the location is empty' do
      expect(Workspace.first).to be nil

      post :create,
           :params => { :workspace => { :location => "", :workspace_type => workspace_type,
                                        :capacity => capacity } }

      expect(Workspace.first).to be nil
    end

    it 'does not save the workspace if the capacity is empty' do
      expect(Workspace.first).to be nil

      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => "" } }

      expect(Workspace.first).to be nil
    end

    it 'does not save the workspace if the capacity is invalid' do
      expect(Workspace.first).to be nil

      post :create,
           :params => { :workspace => { :location => location, :workspace_type => workspace_type,
                                        :capacity => "invalid" } }

      expect(Workspace.first).to be nil
    end

    it 'does not save the workspace if the workspace type is empty' do
      expect(Workspace.first).to be nil

      post :create, :params => { :workspace => { :location => location, :capacity => capacity } }

      expect(Workspace.first).to be nil
    end

    it 'does not save the workspace if the workspace type is invalid' do
      expect(Workspace.first).to be nil

      post :create,
           :params => { :workspace => { :location => location, :workspace_type => "invalid",
                                        :capacity => capacity } }

      expect(Workspace.first).to be nil
    end

    it 'does not save the workspace if the user is not an admin' do
      regular_user = create(:user)
      session[:user_id] = regular_user.id

      expect(Workspace.first).to be nil

      post :create, :params => { :workspace => { :location => location, :capacity => capacity } }

      expect(Workspace.first).to be nil
    end
  end
end
