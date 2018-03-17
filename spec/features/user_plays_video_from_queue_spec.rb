require "spec_helper"

feature "User plays video from queue" do
  given(:alice) { Fabricate(:user) }
  given(:category) { Fabricate(:category) }
  given(:video) { Fabricate(:video, category: category) }

  scenario "clicks play button" do
    Fabricate(:queue_item, user: alice, video: video, position: 1)
    sign_in alice
    visit my_queue_path

    click_on "Play"
    expect(page).to have_selector("video")
    expect(page).to have_content("Watching")
  end
end
