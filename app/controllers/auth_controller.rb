class AuthController < ApplicationController
  def callback
    auth_info = request.env['omniauth.auth']
    email = auth_info['extra']['raw_info'][:name]

    user = validate_user_exists(email)
    if user.nil?
      return
    end

    session[:user] = user

    Rails.logger.info "User with email #{email} authenticated successfully"
    redirect_to '/dashboard'
  end

  def failure
  end

  private

  def validate_user_exists(email)
    user = User.find_by(email: email)
    if user.nil?
      Rails.logger.error "User with email #{email} not found in database"
      redirect_to '/auth/failure'
      return
    end

    return user
  end
end
