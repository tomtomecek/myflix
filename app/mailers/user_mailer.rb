class UserMailer < ActionMailer::Base
  default from: "no-reply@myflix.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Welcome to MyFLiX")
  end

  def send_reset_token(user)
    @user = user
    mail(to: @user.email, subject: "Password reset - MyFLiX")
  end

end