require 'spec_helper'

feature "User signing in" do
  
  given(:tom) { Fabricate(:user) }

  scenario "successful sign in" do
    sign_in(tom)
    
    expect_to_see("You have logged in")
  end

  scenario "unsuccessful login" do
    visit sign_in_path
    
    fill_in_form_and_submit
    
    expect_to_see("Incorrect email or password")
  end

end

def fill_in_form_and_submit
  fill_in "email",    with: "no match"
  fill_in "password", with: "no match"
  click_on "Sign in"
end