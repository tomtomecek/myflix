require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "for authorized user" do
      it "sets @queue_items" do
        tom = Fabricate(:user)
        session[:user_id] = tom.id
        item1 = Fabricate(:queue_item, user: tom)
        item2 = Fabricate(:queue_item, user: tom)
        get :index
        expect(assigns(:queue_items)).to match_array([item1, item2])
      end
    end
  
    context "for unauthorized user" do
      it "redirects to root url" do
        get :index
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "POST create" do
    context "for authorized user" do
      it "redirects to my_queue url" do
        tom = Fabricate(:user)
        session[:user_id] = tom.id
        video = Fabricate(:video)
        post :create, video: video, user: tom
        expect(response).to redirect_to my_queue_url
      end

      it "creates a queue item in current users queue" do
        tom = Fabricate(:user)
        session[:user_id] = tom.id
        video = Fabricate(:video)
        post :create, video: video, user: tom
        expect(QueueItem.count).to eq(1)
      end

      #it "does not create a queue item if user has none"
      
      it "increments position of created item" do
        tom = Fabricate(:user)
        session[:user_id] = tom.id
        video = Fabricate(:video)
        post :create, video: video, user: tom

        expect(QueueItem.count).to eq(1)
      end
      
    end

    context "for unauthorized user" do
      it "redirects to root url" do
        post :create
        expect(response).to redirect_to root_url
      end
    end
  end
end