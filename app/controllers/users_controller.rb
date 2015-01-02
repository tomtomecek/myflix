class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    
    registartion = Registration.new(
      @user, 
      stripe_token: params[:stripeToken], 
      invitation: params[:invitation_token]
    )

    if registartion.successfull?
      flash[:success] = "Welcome to myFlix! You have successfully registered."
      redirect_to sign_in_url
    else
      flash.now[:danger] = registartion.charging_error_message
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