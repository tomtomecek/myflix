class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      UserMailer.welcome_email(@user).deliver
      handle_invitations if params[:invitation_token]
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

  def handle_invitations
    invitation = Invitation.find_by(token: params[:invitation_token])
    if invitation
      Relationship.create(leader: invitation.sender,follower: @user)
      Relationship.create(leader: @user, follower: invitation.sender)
      invitation.update_column(:token, nil)
    end
  end
end