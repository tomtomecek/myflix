require 'spec_helper'

describe Category do
 
  it { should have_many(:videos).order(:title) }

  describe ".recent_videos" do
    let(:category) { Fabricate(:category) }
    
    it "returns max 6 videos" do
      Fabricate.times(7, :video, category: category)
      expect(category.recent_videos.count).to be <= 6
    end

    it "returns all videos if less than 6" do
      Fabricate.times(3, :video, category: category)
      expect(category.recent_videos.count).to be <= 6
    end

    it "returns chronological reversed order" do
      vid1 = Fabricate(:video, category: category, created_at: 2.days.ago)
      vid2 = Fabricate(:video, category: category, created_at: 1.day.ago)
      vid3 = Fabricate(:video, category: category)
      expect(category.recent_videos).to eq([vid3, vid2, vid1])
    end

    it { expect(category.recent_videos).to eq([]) }
  end
end