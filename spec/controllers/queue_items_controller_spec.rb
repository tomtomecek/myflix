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
end