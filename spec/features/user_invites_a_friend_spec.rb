require 'spec_helper'

feature "User invites a friend to MyFLiX" do
  scenario "User invites a friend to MyFLiX" do
    pete = Fabricate(:user)
    sign_in(pete)
    click_link "Invite Friend"

    fill_in "Friend's Name", with: "Kelly"
    fill_in "Friend's Email Address", with: "kelly@example.com"
    fill_in "Invitation Message", with: "Please join this cool site!"
    click_button "Send Invitation"
    expect_to_see("You have invited your friend Kelly to MyFLiX")    
    sign_out(pete)

    open_email("kelly@example.com")
    current_email.click_link "Register Me @ MyFLiX"

    expect(find(:xpath, "//input[@type='email']").value).to eq("kelly@example.com")
    fill_in "Password", with: "password"
    fill_in "Full Name", with: "Kelly Doe"
    click_button "Sign Up"

    fill_in "email", with: "kelly@example.com"
    fill_in "password", with: "password"
    click_button "Sign in"

    click_on "People"
    expect_to_see pete.fullname
    click_link pete.fullname
  end
end