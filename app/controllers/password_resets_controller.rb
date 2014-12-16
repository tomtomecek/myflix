class PasswordResetsController < ApplicationController
  before_action :set_user, only: [:edit, :update]
  before_action :require_valid_token, only: [:edit, :update]

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

  def edit; end

  def update
    if @user.update(password: params[:user][:password])
      @user.set_token_to_nil
      flash[:success] = "Your password has been reset. You can login in."
      redirect_to sign_in_url
    else
      render :edit
    end
  end

private
  
  def set_user
    @user = User.find_by(token: params[:token]) if params[:token]
  end

  def require_valid_token    
    redirect_to invalid_token_url unless @user
  end
end