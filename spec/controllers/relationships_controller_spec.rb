require 'spec_helper'

describe RelationshipsController do

  describe "GET index" do
    it "sets the @followings" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      dan = Fabricate(:user)
      following_bob = Fabricate(:relationship, follower: alice, followed: bob)
      following_dan = Fabricate(:relationship, follower: alice, followed: dan)

      get :index
      expect(assigns(:relationships))
        .to match_array([following_bob, following_dan])
    end

    it_behaves_like "require_sign_in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:bob) { Fabricate(:user) }
    before { set_current_user }
    
    context "with valid inputs" do
      it "redirects to followed user profile" do      
        post :create, followed_id: bob.id
        should redirect_to bob
      end

      it "creates relationship between current user and followed user" do
        post :create, followed_id: bob.id
        expect(Relationship.count).to eq(1)
      end

      it "sets the @user" do
        post :create, followed_id: bob.id
        expect(assigns(:user)).to eq(bob)
      end

      it "sets flash success" do
        post :create, followed_id: bob.id
        should set_the_flash[:success]
      end
    end

    context "with invalid inputs" do
      let(:alice) { Fabricate(:user) }
      let(:bob)   { Fabricate(:user) }
      before do
        set_current_user(alice)
        Fabricate(:relationship, follower: alice, followed: bob)
        post :create, followed_id: bob.id
      end

      it "does not create relationship if already exists" do
        expect(Relationship.count).to eq(1)
      end
      it { should set_the_flash[:info] }
    end

    it_behaves_like "require_sign_in" do
      let(:action) { post :create, followed_id: 1 }
    end
  end

  describe "DELETE destroy" do
    it "redirects to people page" do
      alice = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: alice)
      delete :destroy, id: relationship.id
      should redirect_to people_url
    end

    it "deletes the relationship" do
      alice = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: alice)
      delete :destroy, id: relationship.id
      expect(Relationship.count).to eq(0)
    end

    it "sets flash info" do
      alice = Fabricate(:user)
      set_current_user(alice)
      relationship = Fabricate(:relationship, follower: alice)
      delete :destroy, id: relationship.id
      should set_the_flash[:info]
    end

    it "does not allow user to destroy other users relationships" do
      alice = Fabricate(:user)
      relationship = Fabricate(:relationship, follower: alice)
      doug = Fabricate(:user)
      set_current_user(doug)
      
      delete :destroy, id: relationship.id
      should set_the_flash[:danger]
      expect(Relationship.count).to eq(1)
    end

    it_behaves_like "require_sign_in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end

end