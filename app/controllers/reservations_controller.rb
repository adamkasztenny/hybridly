class ReservationsController < ApplicationController
  include Secured

  def new
    @reservation = Reservation.new
  end

  def create
    @qr_code = nil

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
      @qr_code = ReservationConfirmationService.create_qr_code(@reservation, request.base_url).html_safe
      flash.notice = "Reservation for #{@reservation.date} successful!"
    end

    render :new
  end

  def show_for_date
    @date = params[:date]
    @reservations = Reservation.for_date(@date)
  end

  def verify
    user = User.find(session[:user_id])

    if user.has_role?(:admin)
      @verification_code = params[:verification_code]
      @reservation = Reservation.verify(@verification_code, user)
    else
      render :file => "public/401.html", :status => :unauthorized
    end
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
