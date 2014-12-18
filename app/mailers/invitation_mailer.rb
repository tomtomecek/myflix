class InvitationMailer < ActionMailer::Base
  default from: "no-reply@myflix.com"

  def send_invite_to_a_friend(invitation)
    @invitation = invitation
    mail(to: @invitation.recipient_email, subject: "Invitation to MyFLiX")
  end
end