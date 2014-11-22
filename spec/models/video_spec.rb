require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }

  describe "#self.search_by_title" do

    it "should fail fiding if no video" do
      Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("Inception")).to_not eq(Video.first)
    end

    it "should find 1 video by title" do
      Video.create(title: "Interstellar", description: "a big step for humans")
      expect(Video.search_by_title("Interstellar")).to eq([Video.first])
    end

    it "should find multiple videos by title matching pattern" do
      Video.create(title: "Interstellar", description: "a big step for humans")
      Video.create(title: "stellarium", description: "will be released in 2016")
      expect(Video.search_by_title("stella")).to eq([Video.first, Video.second])
    end
  end


end
