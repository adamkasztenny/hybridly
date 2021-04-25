class WorkspacesController < ApplicationController
  include Secured

  def new
    @workspace = Workspace.new
  end

  def create
    if !workspace_type_valid?(workspace_parameters)
      @workspace = Workspace.new
      @workspace.errors.add(:workspace_type, "is not valid")
      render :new
      return
    end

    @workspace = Workspace.new(workspace_parameters)
    @workspace.user = User.find(session[:user_id])

    if @workspace.save
      flash.notice = "#{@workspace.location} workspace created with a capacity of #{@workspace.capacity} people"
      redirect_to '/dashboard'
    else
      render :new
    end
  end

  private

  def workspace_parameters
    params.require(:workspace).permit(:location, :workspace_type, :capacity)
  end

  def workspace_type_valid?(workspace_parameters)
    workspace_type = workspace_parameters[:workspace_type]
    Workspace.workspace_types.keys.include?(workspace_type)
  end
end
