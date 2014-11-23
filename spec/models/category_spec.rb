require 'spec_helper'

describe Category do
 
  it { should have_many(:videos) }

  describe "#recent_videos" do
    
    it "should return max 6 videos" do
      cat = Category.create(name: "TV shows")
      8.times { Video.create(title: "title", description: "desc", category: cat) }
      expect(cat.recent_videos.count).to be <= 6
    end

    it "should return all videos if less than 6" do
      cat = Category.create(name: "TV shows")
      3.times { Video.create(title: "title", description: "desc", category: cat) }
      expect(cat.recent_videos.count).to be <= 6
    end

    it "should return chronological reversed order" do
      cat = Category.create(name: "TV shows")
      vid1 = Video.create(title: "title1", description: "first", category: cat)
      vid2 = Video.create(title: "title2", description: "second", category: cat)
      vid3 = Video.create(title: "title3", description: "third", category: cat)
      expect(cat.recent_videos).to eq([vid3, vid2, vid1])
    end

    it "returns an empty array if no video" do
      cat = Category.create(name: "TV shows")
      expect(cat.recent_videos).to eq([])
    end

  end

end