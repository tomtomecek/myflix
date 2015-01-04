class UserRegistration

  attr_accessor :charge_error, :status
  attr_reader :user, :stripe_token, :invitation_token
  def initialize(user, stripe_token, invitation_token)
    @user             = user
    @stripe_token     = stripe_token
    @invitation_token = invitation_token
  end

  def register
    if user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: stripe_token,
        description: "sign up payment for #{user.email}"
      )
      if charge.successfull? && user.save
        UserMailer.delay.welcome_email(user.id)
        handle_invitation if invitation_token
        self.status = :success
      else
        self.charge_error = charge.error_message
      end
    end
    self
  end

  def successfull?
    status == :success
  end

  def charging_error_message
    charge_error
  end

private

  def handle_invitation
    invitation = Invitation.find_by(token: invitation_token)
    if invitation
      user.follow(invitation.sender)
      invitation.sender.follow(user)
      invitation.update_column(:token, nil)
    end
  end
end