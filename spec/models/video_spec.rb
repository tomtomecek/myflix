require 'spec_helper'

describe Video do

  it { should belong_to(:category) }
  it { should have_many(:reviews).order('created_at DESC') }
  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:video_url) }

  describe ".search_by_title" do
    let(:interstellar) do
      Fabricate(:video, title: "Interstellar", created_at: 1.day.ago)
    end

    it { expect(Video.search_by_title("")).to eq [] }
    it { expect(Video.search_by_title("no-match")).to eq [] }
    it { expect(Video.search_by_title("Interstellar")).to eq [interstellar] }
    it { expect(Video.search_by_title("Inter")).to eq [interstellar] }

    it "returns an array of multiple videos per pattern" do
      stellarium = Fabricate(:video, title: "stellarium")
      expect(Video.search_by_title("stella")).to eq([stellarium, interstellar])
    end
  end

  describe "#rating" do
    let(:video) { Fabricate(:video) }
    subject { video.rating }

    it "returns float rating as review if 1 review" do
      review = Fabricate(:review, video: video)
      expect(subject).to eq(review.rating.to_f)
    end

    it "returns average rating from all review ratings" do
      Fabricate(:review, video: video, rating: 2)
      Fabricate(:review, video: video, rating: 3)
      expect(subject).to eq(2.5)
    end
  end
end