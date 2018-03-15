require 'spec_helper'

feature "User invites a friend to MyFLiX" do
  scenario "User invites a friend to MyFLiX", :js, :vcr, driver: :selenium_chrome do
    pete = Fabricate(:user)
    sign_in(pete)

    expect_to_invite_a_friend
    expect_friend_to_accept_the_invitation
    friend_signs_in

    expect_friend_follows(pete)
    expect_inviter_follows_friend(pete)
    clear_emails
  end
end

def expect_to_invite_a_friend
  click_link "Invite Friend"
  fill_in "Friend's Name", with: "Kelly"
  fill_in "Friend's Email Address", with: "kelly@example.com"
  fill_in "Invitation Message", with: "Please join this cool site!"
  click_button "Send Invitation"
  expect_to_see("You have invited your friend Kelly to MyFLiX")
  sign_out
end

def expect_friend_to_accept_the_invitation
  open_email("kelly@example.com")
  current_email.click_link "Register Me @ MyFLiX"

  expect(find(:xpath, "//input[@type='email']").value).to eq("kelly@example.com")
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Kelly Doe"
  fill_in "Credit Card Number", with: "4242424242424242"
  fill_in "Security Code", with: "123"
  select "3 - March", from: "date_month"
  select (Time.now.year + 1), from: "date_year"
  click_button "Sign Up"
end

def friend_signs_in
  fill_in "email", with: "kelly@example.com"
  fill_in "password", with: "password"
  click_button "Sign in"
end

def expect_friend_follows(inviter)
  click_on "People"
  expect_to_see inviter.fullname
  sign_out
end

def expect_inviter_follows_friend(inviter)
  sign_in(inviter)
  click_on "People"
  expect_to_see inviter.fullname
end