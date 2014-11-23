class SessionsController < ApplicationController

  def new
    redirect_to home_url if logged_in?
  end

  def create
    user = User.find_by(email: params[:email].downcase)

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have logged in."
      redirect_to home_url
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end

end