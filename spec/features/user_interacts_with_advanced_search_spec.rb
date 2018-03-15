require 'spec_helper'

feature "User interacts with advanced search", :elasticsearch do
  given(:refresh_index) do
    Video.import
    Video.__elasticsearch__.refresh_index!
  end

  background do
    star_wars1 = Fabricate(:video, title: "Star Wars: Episode I")
    star_wars2 = Fabricate(:video, title: "Star Wars: Episode II")
    star_trek  = Fabricate(:video, title: "Star Trek")
    bride_wars = Fabricate(:video, title: "Bride Wars", description: "some wedding movie!")
    Fabricate(:review, video: star_wars1, rating: 5, body: "awesome movie !!!1")
    Fabricate(:review, video: star_wars2, rating: 3)
    Fabricate(:review, video: star_trek,  rating: 4)
    Fabricate(:review, video: star_trek,  rating: 5)
    refresh_index
    sign_in
  end

  scenario "user interacts with advanced search" do
    click_on "Advanced Search"
    search_for("Star Wars")
    validate_search_by_title
    validate_highlighting(4)

    search_for("wedding movie")
    validate_search_by_description
    validate_highlighting(2)

    search_for("awesome movie", include_reviews: true)
    validate_search_by_reviews
    validate_highlighting(2)

    search_for(rating_from: "4.4", rating_to: "4.6")
    validate_search_by_average_ratings
    validate_highlighting(0)
  end

  def validate_highlighting(count)
    expect(page).to have_css ".label-highlight", count: count
  end

  def search_for(query, options = {})
    if query.is_a? Hash
      options = query
      query = nil
    end

    within(".advanced_search") do
      fill_in "query", with: query

      check "Include Reviews" if options[:include_reviews]

      select options[:rating_from], from: "rating_from" if options[:rating_from]
      select options[:rating_to], from: "rating_to" if options[:rating_to]

      click_button "Search"
    end
  end

  def validate_search_by_title
    expect(page).to have_content "2 videos found"
    expect(page).to have_css("article", count: 2)
    expect(page).to have_content "Star Wars: Episode I"
    expect(page).to have_content "Star Wars: Episode II"
    expect(page).to have_no_content "Star Trek"
    expect(page).to have_no_content "Bride Wars"
  end

  def validate_search_by_description
    expect(page).to have_content "Bride Wars"
    expect(page).to have_no_content "Star"
  end

  def validate_search_by_reviews
    expect(page).to have_content "Star Wars: Episode I"
    expect(page).to have_no_content "Star Wars: Episode II"
    expect(page).to have_no_content "Star Trek"
    expect(page).to have_no_content "Bride Wars"
  end

  def validate_search_by_average_ratings
    expect(page).to have_content "Star Trek"
    expect(page).to have_no_content "Star Wars: Episode I"
    expect(page).to have_no_content "Star Wars: Episode II"
    expect(page).to have_no_content "Bride Wars"
  end
end
