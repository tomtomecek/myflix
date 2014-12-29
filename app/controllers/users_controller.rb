class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    ActiveRecord::Base.transaction do
      begin
        @user.save!

        charge = StripeWrapper::Charge.create(
          amount: 999,
          card: params[:stripeToken],
          description: "sign up payment for #{@user.email}"
        )
        if charge.successfull?
          UserMailer.delay.welcome_email(@user.id)
          handle_invitation if params[:invitation_token]
          flash[:success] = "Welcome to myFlix, you have successfully registered."
          redirect_to sign_in_url
        else
          flash[:danger] = charge.error_message
          redirect_to register_url
        end
      rescue ActiveRecord::RecordInvalid
        render :new
      end
    end
  end

  def show
    @user = User.find(params[:id])
  end

private

  def user_params
    params.require(:user).permit(:email, :password, :fullname)
  end

  def handle_invitation
    invitation = Invitation.find_by(token: params[:invitation_token])
    if invitation
      @user.follow(invitation.sender)
      invitation.sender.follow(@user)
      invitation.update_column(:token, nil)
    end
  end
end