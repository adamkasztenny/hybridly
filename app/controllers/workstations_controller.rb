class WorkstationsController < ApplicationController
  include Secured

  def new
    @workstation = Workstation.new
  end

  def create
    @workstation = Workstation.new(workstation_parameters)
    @workstation.user = User.find(session[:user_id])

    if @workstation.save
      flash.notice = "#{@workstation.location} workstation created with a capacity of #{@workstation.capacity} people"
      redirect_to '/dashboard'
    else
      render :new
    end
  end

  private

  def workstation_parameters
    params.require(:workstation).permit(:location, :capacity)
  end
end
