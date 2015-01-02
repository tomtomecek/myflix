class Registration

  attr_accessor :charge_error
  attr_reader :user, :stripe_token, :invitation_token
  def initialize(user, options={})
    @user = user
    @stripe_token = options[:stripe_token]
    @invitation_token = options[:invitation]
  end

  def successfull?
    if user.valid?
      charge = StripeWrapper::Charge.create(
        amount: 999,
        card: stripe_token,
        description: "sign up payment for #{user.email}"
      )
      if charge.successfull? && user.save
        UserMailer.delay.welcome_email(user.id)
        handle_invitation if invitation_token
        true
      else
        self.charge_error = charge.error_message
        false
      end
    else
      false
    end
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