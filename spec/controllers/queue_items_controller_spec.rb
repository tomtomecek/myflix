require 'spec_helper'

describe QueueItemsController do
  describe "GET index" do
    context "for authorized users" do
      it "sets @queue_items" do
        current_user = Fabricate(:user)
        session[:user_id] = current_user.id
        item1 = Fabricate(:queue_item, user: current_user)
        item2 = Fabricate(:queue_item, user: current_user)
        
        get :index
        expect(assigns(:queue_items)).to match_array([item1, item2])
      end
    end
  
    context "for unauthorized users" do
      it "redirects to root url" do
        get :index
        expect(response).to redirect_to root_url
      end
    end
  end
end