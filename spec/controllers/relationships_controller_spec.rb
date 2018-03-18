require 'spec_helper'

describe RelationshipsController do

  describe "GET index" do
    it "sets the @relationships" do
      alice = Fabricate(:user)
      set_current_user(alice)
      bob = Fabricate(:user)
      dan = Fabricate(:user)
      following_bob = Fabricate(:relationship, follower: alice, leader: bob)
      following_dan = Fabricate(:relationship, follower: alice, leader: dan)

      get :index
      expect(assigns(:relationships))
        .to match_array([following_bob, following_dan])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    let(:alice) { Fabricate(:user) }
    let(:bob)   { Fabricate(:user) }
    before { set_current_user(alice) }
    
    context "with valid inputs" do
      it "redirects to people page" do
        post :create, leader_id: bob.id
        expect(response).to redirect_to people_url
      end

      it "creates relationship between current user and leader" do
        post :create, leader_id: bob.id
        expect(alice.following_relationships.first.leader).to eq(bob)
      end
    end

    context "with invalid inputs" do
      it "does not create relationship if user follows the leader" do
        Fabricate(:relationship, follower: alice, leader: bob)
        post :create, leader_id: bob.id
        expect(Relationship.count).to eq(1)
      end

      it "does not allow one to follow themselves" do
        post :create, leader_id: alice.id
        expect(Relationship.count).to eq(0)
      end  
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, leader_id: 1 }
    end
  end

  describe "DELETE destroy" do
    let(:alice) { Fabricate(:user) }
    let(:relationship) { Fabricate(:relationship, follower: alice) }
    before { set_current_user(alice) }
    
    it "redirects to people page" do
      delete :destroy, id: relationship
      expect(response).to redirect_to people_url
    end

    it "sets flash info" do
      delete :destroy, id: relationship
      expect(subject).to set_the_flash[:info]
    end

    context "when user is follower" do
      it "destroys the relationship" do
        delete :destroy, id: relationship
        expect(Relationship.count).to eq(0)
      end
    end
    
    context "when user is not follower" do
      it "does not destroy relationship" do
        clear_current_user
        doug = Fabricate(:user)
        set_current_user(doug)
        delete :destroy, id: relationship
        expect(Relationship.count).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end
end
