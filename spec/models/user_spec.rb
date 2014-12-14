require 'spec_helper'

describe User do
  it { should have_many(:reviews).order(created_at: :desc) }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:fullname) }


  it "creates user with downcased email" do
    tom = Fabricate(:user, email: "TEST@EXAMPLE.COM")
    expect(tom.reload.email).to eq("test@example.com")
  end

  describe "#queued_video?" do
    it "returns true if current user queued video" do
      tom = Fabricate(:user)
      video = Fabricate(:video)
      Fabricate(:queue_item, user: tom, video: video)
      expect(tom.queued_video?(video)).to be true
    end
    
    it "returns false if current user did not queue video" do
      tom = Fabricate(:user)
      video = Fabricate(:video)
      expect(tom.queued_video?(video)).to be false
    end
  end

  describe "#followers_total" do
    it "returns 0 if there are no followers" do
      bob = Fabricate(:user)
      expect(bob.followers_total).to eq(0)
    end

    it "returns 1 if there is 1 follower" do
      bob = Fabricate(:user)
      Fabricate(:relationship, followed: bob)
      expect(bob.followers_total).to eq(1)
    end

    it "returns 10 if there are 10 followers" do
      bob = Fabricate(:user)
      Fabricate.times(10, :relationship, followed: bob)
      expect(bob.followers_total).to eq(10)
    end
  end

end