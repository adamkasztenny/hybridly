module Secured
  extend ActiveSupport::Concern

  included do
    before_action :logged_in?
  end

  private

  def logged_in?
    redirect_to '/' unless session[:user_id].present?
  end
end
