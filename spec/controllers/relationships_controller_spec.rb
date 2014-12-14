require 'spec_helper'

describe RelationshipsController do

  describe "GET people" do

    it "sets the @followings" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      dan = Fabricate(:user)
      Fabricate(:relationship, follower: alice, followed: bob)
      Fabricate(:relationship, follower: alice, followed: dan)

      get :people
      expect(assigns(:followings)).to match_array([bob, dan])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :people }
    end
  end

end