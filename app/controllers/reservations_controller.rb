class ReservationsController < ApplicationController
  include Secured

  def new
    @reservation = Reservation.new
  end

  def create
    if !workspace_is_valid?(reservation_parameters)
      @reservation = Reservation.new
      @reservation.errors.add(:workspace, "does not exist")
      render :new
      return
    end

    @reservation = Reservation.new(reservation_parameters)
    @reservation.verification_code = SecureRandom.uuid
    @reservation.user = User.find(session[:user_id])

    if @reservation.save
      flash.notice = "Reservation for #{@reservation.date} successful!"
      redirect_to '/dashboard'
    else
      render :new
    end
  end

  def show_for_date
    @date = params[:date]
    @reservations = Reservation.for_date(@date)
  end

  private

  def reservation_parameters
    params.require(:reservation).permit(:date, :workspace_id)
  end

  def workspace_is_valid?(params)
    workspace_id = params[:workspace_id]
    workspace_id.blank? || Workspace.exists?(id: workspace_id)
  end
end
