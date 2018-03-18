def sign_in(user=nil)
  user ||= Fabricate(:user)
  visit sign_in_path
  fill_in "email",    with: user.email
  fill_in "password", with: user.password
  click_button "Sign in"
end

def sign_out
  visit sign_out_path
end

def expect_to_see(text, options = {})
  expect(page).to have_content(text, options)
end

def expect_to_not_see(text, options = {})
  expect(page).to have_no_content(text, options)
end

def expect_to_be_in(path)
  expect(current_path).to eq(path)
end

def click_on_video_on_home_page(video)
  find(:xpath, "//a[@href='/videos/#{video.id}']").click
end
