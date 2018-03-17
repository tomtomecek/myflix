class UserRegistration

  attr_accessor :error_message, :status
  attr_reader :user, :stripe_token, :invitation_token
  def initialize(user, stripe_token, invitation_token=nil)
    @user             = user
    @stripe_token     = stripe_token
    @invitation_token = invitation_token
  end

  def register
    if user.valid?
      subscription = StripeWrapper::Customer.create(
        card: stripe_token,
        email: user.email
      )
      if subscription.successfull? && user.save
        Subscription.create(
          user: user,
          customer_id: subscription.customer.id,
          subscription_id: subscription.customer.subscriptions.first.id
        )
        send_welcome_message_email(user)
        handle_invitation if invitation_token
        self.status = :success
      else
        self.status = :failed
        self.error_message = subscription.error_message
      end
    else
      self.status = :failed
      self.error_message = "Invalid user details."
    end
    self
  end

  def successfull?
    status == :success
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

  def send_welcome_message_email(user)
    UserMailer.delay.welcome_email(user.id)
  end
end