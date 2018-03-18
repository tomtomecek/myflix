class UserMailer < ActionMailer::Base
  default from: "no-reply@myflix.com"

  def welcome_email(user_id)
    @user = User.find(user_id)
    mail(to: admin_or_user(@user.email), subject: "Welcome to MyFLiX")
  end

  def send_reset_token(user_id)
    @user = User.find(user_id)
    mail(to: admin_or_user(@user.email), subject: "Password reset - MyFLiX")
  end

private

  def admin_or_user(email)
    if Rails.env.staging?
      ENV["ADMIN_EMAIL"]
    else
      email
    end
  end
end
