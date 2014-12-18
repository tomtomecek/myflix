require 'spec_helper'

feature "User invites a friend to MyFLiX" do
  scenario "User invites a friend to MyFLiX" do
    pete = Fabricate(:user)
    sign_in(pete)

    invite_a_friend
    friend_accepts_the_invitation
    friend_signs_in

    friend_follows(pete)
    inviter_follows_friend(pete)
    clear_emails
  end
end

def invite_a_friend
  click_link "Invite Friend"
  fill_in "Friend's Name", with: "Kelly"
  fill_in "Friend's Email Address", with: "kelly@example.com"
  fill_in "Invitation Message", with: "Please join this cool site!"
  click_button "Send Invitation"
  expect_to_see("You have invited your friend Kelly to MyFLiX")
  sign_out
end

def friend_accepts_the_invitation
  open_email("kelly@example.com")
  current_email.click_link "Register Me @ MyFLiX"

  expect(find(:xpath, "//input[@type='email']").value).to eq("kelly@example.com")
  fill_in "Password", with: "password"
  fill_in "Full Name", with: "Kelly Doe"
  click_button "Sign Up"
end

def friend_signs_in
  fill_in "email", with: "kelly@example.com"
  fill_in "password", with: "password"
  click_button "Sign in"
end

def friend_follows(inviter)
  click_on "People"
  expect_to_see inviter.fullname
  sign_out
end

def inviter_follows_friend(inviter)
  sign_in(inviter)
  click_on "People"
  expect_to_see inviter.fullname
end