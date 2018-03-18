require 'spec_helper'

feature "user interacts with my queue" do
  given!(:tv_shows)     { Fabricate(:category)                  }
  given!(:futurama)     { Fabricate(:video, category: tv_shows) }
  given!(:south_park)   { Fabricate(:video, category: tv_shows) }
  given!(:interstellar) { Fabricate(:video, category: tv_shows) }

  scenario "user adds and reorders my queue videos" do
    sign_in

    add_video_to_queue(futurama)
    expect_video_to_be_in_queue(futurama)

    visit video_path(futurama)
    expect_link_to_not_be_seen("+ My Queue")

    add_video_to_queue(south_park)
    add_video_to_queue(interstellar)

    set_video_position(futurama, 6)
    set_video_position(south_park, 1)
    set_video_position(interstellar, 2)
    update_queue

    expect_video_position(south_park, 1)
    expect_video_position(interstellar, 2)
    expect_video_position(futurama, 3)
  end

  def expect_video_to_be_in_queue(video)
    expect(page).to have_content video.title
  end

  def expect_link_to_not_be_seen(link)
    expect(page).to_not have_content link
  end

  def add_video_to_queue(video)
    click_on "Videos"
    find("a[href='#{video_path(video)}']").click
    click_on "+ My Queue"
  end

  def set_video_position(video, position)
    within(:xpath, "//tr[contains(.,'#{video.title}')]") do
      fill_in "queue_items[][position]", with: position
    end
  end

  def update_queue
    click_button "Update Instant Queue"
  end

  def expect_video_position(video, position)
    expect(find(:xpath, "//tr[contains(.,'#{video.title}')]//input[@type='text']").value).to eq(position.to_s)
  end
end
