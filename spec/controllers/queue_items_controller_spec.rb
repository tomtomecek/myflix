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
      let(:video) { Fabricate(:video) }
      let(:tom)   { Fabricate(:user) }
      
      before { session[:user_id] = tom.id }

      it "redirects to my_queue url" do
        post :create, video_id: video.id
        expect(response).to redirect_to my_queue_url
      end

      it "creates a queue item in current users queue" do
        post :create, video_id: video.id
        expect(QueueItem.count).to eq(1)
      end

      it "creates a queue item associated with video" do
        post :create, video_id: video.id
        expect(QueueItem.first.video).to eq(video)
      end

      it "creates a queue item associated with user" do
        post :create, video_id: video.id, user: tom
        expect(QueueItem.first.user).to eq(tom)
      end

      it "increments position of created item" do
        Fabricate(:queue_item, video: video, user: tom)
        futurama = Fabricate(:video)
        post :create, video_id: futurama.id
        futurama_queue_item = QueueItem.where(video_id: futurama.id, user: tom).first
        expect(futurama_queue_item.position).to eq(2)
      end

      it "does not add the same video to the queue twice" do
        Fabricate(:queue_item, video: video, user: tom)
        post :create, video_id: video.id, user: tom
        expect(tom.queue_items.count).to eq(1)
      end
      
    end

    context "for unauthorized user" do
      it "redirects to root url" do
        post :create
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "DELETE destroy" do
    context "for authorized user" do
      
      it "redirects to my_queue" do
        session[:user_id] = Fabricate(:user).id
        queue_item        = Fabricate(:queue_item)
        delete :destroy, id: queue_item.id
        expect(response).to redirect_to my_queue_url
      end
      
      it "destroys the queue_item" do
        tom               = Fabricate(:user)
        session[:user_id] = tom.id
        queue_item        = Fabricate(:queue_item, user: tom)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(0)
      end

      it "does not destroy the queue item of different user" do
        tom               = Fabricate(:user)
        alice             = Fabricate(:user)
        session[:user_id] = tom.id
        queue_item        = Fabricate(:queue_item, user: alice)
        delete :destroy, id: queue_item.id
        expect(QueueItem.count).to eq(1)
      end
    end

    context "for unauthorized user" do
      it "redirects to root url" do
        delete :destroy, id: 1
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "PATCH reorder" do
    context 'for authorized user' do
      let(:tom) { Fabricate(:user) }
      before { session[:user_id] = tom.id }

      it "redirects to my_queue_url" do
        patch :reorder
        expect(response).to redirect_to my_queue_url
      end

      it "updates positions of all queue_items for user" do
        queue_item1 = Fabricate(:queue_item, user: tom)
        queue_item2 = Fabricate(:queue_item, user: tom)
        queue_item3 = Fabricate(:queue_item, user: tom)
        patch :reorder, positions: [2, 1, 3]
        expect(tom.queue_items).to eq([queue_item2, queue_item1, queue_item3])
      end

      context "does not update any position" do
        it "when there is only 1 queue_item"

        it "when any position is blank" do
        end

        it "when all items are not integers" do
        end

        it "when there are duplicate positions" do
        end
      end
    end

    context "for unauthorized user" do
      it "redirects to root_url" do
        patch :reorder
        expect(response).to redirect_to root_url
      end
    end
  end
end