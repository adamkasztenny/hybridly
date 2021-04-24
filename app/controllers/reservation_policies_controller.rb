class ReservationPoliciesController < ApplicationController
  include Secured

  def new
    @reservation_policy = ReservationPolicy.new
  end

  def create
    @reservation_policy = ReservationPolicy.new(reservation_policy_parameters)
    @reservation_policy.user = User.find(session[:user_id])

    if @reservation_policy.save
      flash.notice = "Policy updated to permit #{@reservation_policy.capacity} people in the office"
      redirect_to '/dashboard'
    else
      render :new
    end
  end

  private

  def reservation_policy_parameters
    params.require(:reservation_policy).permit(:capacity)
  end
end
