require 'spec_helper'

feature "user socializes in myflix" do  
  
  scenario "user follows and unfollows" do
    alice    = Fabricate(:user)
    bob      = Fabricate(:user)
    tv_shows = Fabricate(:category)
    futurama = Fabricate(:video, category: tv_shows)
    Fabricate(:review, video: futurama, user: bob)
    
    sign_in(alice)
    
    click_on_video_on_home_page(futurama)
    expect_to_be_in video_path(futurama)
    click_on_reviewer(bob)
    expect_to_be_in user_path(bob)
    follow_user

    click_on "People"
    expect_to_be_in people_path
    within_followings_table do
      expect_to_see(bob.fullname)
      unfollow_user
    end
    expect_to_see("You have unfollowed #{bob.fullname}")
    within_followings_table do
      expect_to_not_see(bob.fullname)
    end
  end

end

def click_on_reviewer(reviewer)
  find(:xpath, "//a[@href='/users/#{reviewer.id}']").click
end

def follow_user  
  click_on "Follow"
end

def unfollow_user
  find(:xpath, "//a[@data-method='delete']").click
end

def within_followings_table(&block)
  within(:xpath, "//table") do
    yield
  end
end