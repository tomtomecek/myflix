require 'spec_helper'

feature "user resets password" do
  scenario "user follows reset password workflow" do
    alice = Fabricate(:user, email: "alice@email.com", password: "old-password")
    visit sign_in_path
    click_link "Forgot password?"
    expect_to_see "Forgot Password?"
    expect_to_be_in password_reset_path

    fill_in "Email Address", with: "alice@email.com"
    click_button "Send Email"

    open_email("alice@email.com")
    click_password_reset_link_in_email
    expect_to_be_in reset_password_path(alice.reload.token)

    expect_to_see("Reset Your Password")

    fill_in_new_password_and_submit
    expect_to_be_in sign_in_path

    fill_in_sign_in_details_and_submit
    expect_to_be_in home_path
  end

  def click_password_reset_link_in_email
    current_email.click_link "Reset password link"
  end

  def fill_in_new_password_and_submit
    fill_in "New Password", with: "new-password"
    click_button "Reset Password"
  end

  def fill_in_sign_in_details_and_submit
    fill_in "email", with: "alice@email.com"
    fill_in "password", with: "new-password"
    click_button "Sign in"
  end
end
