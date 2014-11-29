require 'spec_helper'

feature "Signing in" do
  
  background do
    Fabricate(:user, email: "t.t@example.com", password: "password")
  end

  scenario "successful login" do
    visit sign_in_path
    
    fill_in "Email",    with: "t.t@example.com"
    fill_in "Password", with: "password"
    click_on "Sign in"
    
    page.should have_content "You have logged in"
  end

  scenario "unsuccessful login" do
  end
end