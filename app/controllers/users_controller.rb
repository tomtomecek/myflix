class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver
      if params[:invitation_token]
        invitation = Invitation.find_by(token: params[:invitation_token])
        if invitation
          Relationship.create(leader: invitation.sender,follower: @user)
          Relationship.create(leader: @user, follower: invitation.sender)
        end  
      end
      flash[:success] = "Welcome to myFlix, you have successfully registered."
      redirect_to sign_in_url
    else
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