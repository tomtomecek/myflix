require 'spec_helper'

feature "admin adds video" do
  background { Fabricate(:category, name: "Movies") }

  scenario "admin adds video and user checks the same video" do
    admin = Fabricate(:admin)
    sign_in(admin)
    expect_to_see "Add a New Video"

    fill_in_video_details_select_category_upload_files_and_submit
    video = Video.first
    sign_out

    sign_in
    click_on "Videos"
    expect_to_see_small_cover(video)
    click_on_video(video)
    expect_to_see_large_cover(video)

    click_link "Watch Now"
    expect_to_see_embedded_video(video)
  end

  def fill_in_video_details_select_category_upload_files_and_submit
    fill_in "Title", with: "Interstellar"
    select "Movies", from: "Category"
    fill_in "Description", with: "Awesome movie"
    attach_file 'Large cover', 'spec/support/interstellar_large.jpg'
    attach_file 'Small cover', 'spec/support/interstellar.jpg'
    fill_in "Video URL", with: interstellar_video_url
    click_button "Add Video"
  end

  def interstellar_video_url
    "https://www.example.com/my_bucket/video.mp4"
  end

  def expect_to_see_small_cover(video)
    expect(page).to have_css("img[src='#{video.small_cover_url}']")
  end

  def expect_to_see_large_cover(video)
    expect(page).to have_css("img[src='#{video.large_cover_url}']")
  end

  def click_on_video(video)
    find(:xpath, "//a[@href='/videos/#{video.id}']").click
  end

  def expect_to_see_embedded_video(video)
    within(:xpath, "//video") do
      expect(page).to have_css("source[src='#{video.video_url}']")
    end
  end
end
