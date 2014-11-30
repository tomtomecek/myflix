require 'spec_helper'

feature "User signing in" do
  
  given(:tom) { Fabricate(:user) }

  scenario "successful sign in" do
    sign_in(tom)
    
    expect(page).to have_content "You have logged in"    
  end

  scenario "unsuccessful login" do
    visit sign_in_path
    
    fill_in "email",    with: tom.email
    fill_in "password", with: "no match"
    click_on "Sign in"
    
    expect(page).to have_content "Incorrect email or password"
  end

end