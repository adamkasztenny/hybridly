class ReservationsController < ApplicationController
  include Secured

  def new
    @reservation = Reservation.new
  end

  def create
    @reservation = Reservation.new(reservation_parameters)
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
    params.require(:reservation).permit(:date)
  end
end
