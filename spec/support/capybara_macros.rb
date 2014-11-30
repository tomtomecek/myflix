def sign_in(a_user=nil)
  user = a_user || Fabricate(:user)
  visit sign_in_path
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_on "Sign in"
end