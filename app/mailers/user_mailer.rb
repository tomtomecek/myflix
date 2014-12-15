class UserMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail(from: "no-reply@myflix.com",
           to: @user.email,
      subject: "Welcome to MyFLiX")
  end
end