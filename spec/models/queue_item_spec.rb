require 'spec_helper'

describe QueueItem do
  it { should belong_to(:user) }
  it { should belong_to(:video) }
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

  describe "#position=" do
    it "sets position to 1 for first queue_item in current user's queue" do
      user       = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user)
      expect(user.queue_items.first.position).to eq(1)
    end

    it "sets position to 3 for second queue_item in current user's queue" do
      user       = Fabricate(:user)
      Fabricate.times(3, :queue_item, user: user)
      expect(user.queue_items.last.position).to eq(3)
    end
    
  end

end