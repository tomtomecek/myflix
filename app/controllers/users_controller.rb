class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    registration = UserRegistration.new(@user, params[:stripeToken], params[:invitation_token]).register

    if registration.successfull?
      flash[:success] = "Welcome to myFlix! You have successfully registered."
      redirect_to sign_in_url
    else
      flash.now[:danger] = registration.charging_error_message
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :fullname)
  end  
end