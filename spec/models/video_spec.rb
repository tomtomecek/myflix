require 'spec_helper'

describe Video do
  it "saves a new Video" do
    vid = Video.new(title: "Terminator", 
                    description: "Skynet takes over the world", 
                    small_cover_url: "/tmp/terminator.jpg", 
                    large_cover_url: "/tmp/terminator_large.jpg")
    vid.save

    expect(Video.first.title).to eq("Terminator")
    expect(Video.first.description).to eq("Skynet takes over the world")
    expect(Video.first.small_cover_url).to eq("/tmp/terminator.jpg")
    expect(Video.first.large_cover_url).to eq("/tmp/terminator_large.jpg")
  end


  it "can have a category" do
    cat = Category.create(name: "Movies")
    vid = Video.create(title: "Terminator", category: cat)
    expect(Video.first.category).to eq(Category.first)
  end
end
