require 'spec_helper'

describe Category do
  
  it "saves itself" do
    cat = Category.new(name: "TV shows")
    cat.save
    expect(Category.first).to eq(cat)
  end

  it "has many videos" do
    cat = Category.create(name: "Movies")
    video1 = Video.create(title: "Terminator1", category: cat)
    video2 = Video.create(title: "Terminator2", category: cat)
    expect(Category.first.videos).to include(video1, video2)
    expect(Category.first.videos).to eq([video1, video2])  # Order matters
  end

  it { should have_many(:videos) }


end