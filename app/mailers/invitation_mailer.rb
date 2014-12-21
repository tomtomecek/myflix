class InvitationMailer < ActionMailer::Base
  default from: "no-reply@myflix.com"

  def send_invite_to_a_friend(invitation)
    @invitation = invitation
    mail(to: admin_or_user(invitation.recipient_email), subject: "Invitation to MyFLiX")
  end

private

  def admin_or_user(email)
    if Rails.env.staging?
      ENV['admin_email']
    else
      email
    end
  end

end