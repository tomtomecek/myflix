class PasswordResetsController < ApplicationController

  def create
    user = User.find_by(email: params[:email].downcase)
    if user
      user.generate_token
      UserMailer.send_reset_token(user).deliver      
      redirect_to confirm_password_reset_url
    else
      render :new
    end
  end

end