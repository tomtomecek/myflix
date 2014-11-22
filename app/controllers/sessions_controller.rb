class SessionsController < ApplicationController

  def create
    user = User.find_by(params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:success] = "You have logged in."
      redirect_to home_url
    else
      flash.now[:danger] = "Incorrect email or password. Please try again."
      render :new
    end
  end

end