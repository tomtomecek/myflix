require 'spec_helper'

feature "User signing in" do
  scenario "successful sign in" do
    sign_in
    expect_to_see("You have logged in")
  end

  scenario "unsuccessful login" do
    visit sign_in_path
    fill_in_form_and_submit
    expect_to_see("Incorrect email or password")
  end

  def fill_in_form_and_submit
    fill_in "email",    with: "no match"
    fill_in "password", with: "no match"
    click_on "Sign in"
  end
end
