require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
  it { should validate_numericality_of(:position).only_integer }
  it { should delegate_method(:video_title).to(:video).as(:title) }
  it { should delegate_method(:category).to(:video) }
  it { should delegate_method(:category_name).to(:category).as(:name) }


  describe "#rating" do
    let(:video) { Fabricate(:video) }
    let(:user)  { Fabricate(:user) }

    it "returns rating from the review when the review is present" do
      review     = Fabricate(:review, user: user, video: video, rating: 5)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to eq(5)
    end

    it "returns nil when the is missing" do
      queue_item = Fabricate(:queue_item, user: user, video: video)
      expect(queue_item.rating).to be nil
    end
  end
end