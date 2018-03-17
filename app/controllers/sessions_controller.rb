class SessionsController < ApplicationController
  def new
    redirect_to home_url if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.activated? && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have logged in."
      if current_user.admin?
        redirect_to new_admin_video_url
      else
        redirect_to home_url
      end
    elsif user && !user.activated?
      flash.now[:danger] = "Your account is deactivated."
      render :new
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:success] = "You have logged out."
    redirect_to root_url
  end
end
