class InvitationsController < AuthenticatedController

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(invitation_params)

    if @invitation.save
      InvitationMailer.delay.send_invite_to_a_friend(@invitation)
      flash[:success] = "You have invited your friend #{@invitation.recipient_name} to MyFLiX"
      redirect_to home_url
    else
      render :new
    end    
  end

private

  def invitation_params
    params.require(:invitation).permit(:recipient_name, :recipient_email, :message).merge!(sender: current_user)
  end
end