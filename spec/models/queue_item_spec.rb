require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }
  it { should delegate_method(:video_title).to(:video).as(:title) }
  it { should delegate_method(:category).to(:video) }
  it { should delegate_method(:category_name).to(:category).as(:name) }


  describe "#rating" do
    let(:video)  { Fabricate(:video) }
    let(:tom)    { Fabricate(:user) }

    it "returns review rating when the review is present" do
      review     = Fabricate(:review, user: tom, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, user: tom, video: video)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when the review is missing" do
      queue_item = Fabricate(:queue_item, user: tom, video: video)
      expect(queue_item.rating).to be nil
    end
  end

  describe "#rating=" do
    let(:video)      { Fabricate(:video) }
    let(:tom)        { Fabricate(:user) }
    let(:queue_item) { Fabricate(:queue_item, user: tom, video: video) }

    it "changes the rating of the review if the review is present" do
      review = Fabricate(:review, user: tom, video: video, rating: 2)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it "clears the rating of the review if the review is present" do
      review = Fabricate(:review, user: tom, video: video, rating: 2)
      queue_item.rating = nil
      expect(Review.first.rating).to be nil
    end

    it "creates a review with the rating if the review is not present" do
      queue_item.rating = 3
      expect(Review.first.rating).to eq(3)
    end
  end
  
end