require 'spec_helper'

describe User do
  it { is_expected.to have_many(:reviews).order(created_at: :desc) }
  it { is_expected.to have_many(:queue_items).order(:position) }
  it { is_expected.to have_many(:following_relationships)
                        .class_name("Relationship")
                        .with_foreign_key(:follower_id) }
  it { is_expected.to have_many(:leading_relationships)
                        .class_name("Relationship")
                        .with_foreign_key(:leader_id) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).case_insensitive }
  it { is_expected.to validate_presence_of(:password) }
  it { is_expected.to ensure_length_of(:password).is_at_least(6) }
  it { is_expected.to validate_presence_of(:fullname) }

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

  describe "#follows?(another_user)" do
    it "returns true if current user follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: bob, follower: alice)
      expect(alice.follows?(bob)).to be true
    end

    it "returns false if current user does not follow another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      Fabricate(:relationship, leader: alice, follower: bob)
      expect(alice.follows?(bob)).to be false
    end
  end

  describe "#follow" do
    it "follows another user" do
      alice = Fabricate(:user)
      bob = Fabricate(:user)
      alice.follow(bob)
      expect(alice.follows?(bob)).to be true
    end

    it "does not follow self" do
      alice = Fabricate(:user)
      alice.follow(alice)
      expect(alice.follows?(alice)).to be false
    end
  end

  describe "#set_token_to_nil" do
    it "sets token to nil" do
      alice = Fabricate(:user, token: SecureRandom.urlsafe_base64)
      alice.set_token_to_nil
      expect(alice.token).to be nil
    end
  end

  describe "#deactivate!" do
    it "deactivates user" do
      alice = Fabricate(:user, activated: true)
      alice.deactivate!
      expect(alice.activated?).to be false
    end
  end
end
