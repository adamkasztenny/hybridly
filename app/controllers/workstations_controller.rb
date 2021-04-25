class WorkstationsController < ApplicationController
  include Secured

  def new
    @workstation = Workstation.new
  end

  def create
    if !workstation_type_valid?(workstation_parameters)
      render :new
      return
    end

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
    params.require(:workstation).permit(:location, :workstation_type, :capacity)
  end

  def workstation_type_valid?(workstation_parameters)
    workstation_type = workstation_parameters[:workstation_type]
    Workstation.workstation_types.keys.include?(workstation_type.to_s)
  end
end
