require 'spec_helper'

describe QueueItemsController do
  
  before { set_current_user }

  describe "GET index" do
    it "sets @queue_items" do
      item1 = Fabricate(:queue_item, user: current_user)
      item2 = Fabricate(:queue_item, user: current_user)
      get :index
      expect(assigns(:queue_items)).to match_array([item1, item2])
    end
  
    it_behaves_like "require sign in" do
      let(:action) { get :index }
    end
  end

  describe "POST create" do
    context "for authorized user" do
      let(:video) { Fabricate(:video) }
      
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
        post :create, video_id: video.id, user: current_user
        expect(QueueItem.first.user).to eq(current_user)
      end

      it "increments position of created item" do
        Fabricate(:queue_item, video: video, user: current_user)
        futurama = Fabricate(:video)
        post :create, video_id: futurama.id
        futurama_queue_item = QueueItem.where(video_id: futurama.id, user: current_user).first
        expect(futurama_queue_item.position).to eq(2)
      end

      it "does not add the same video to the queue twice" do
        Fabricate(:queue_item, video: video, user: current_user)
        post :create, video_id: video.id, user: current_user
        expect(current_user.queue_items.count).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end
  end

  describe "DELETE destroy" do
    it "redirects to my_queue" do
      queue_item = Fabricate(:queue_item)
      delete :destroy, id: queue_item.id
      expect(response).to redirect_to my_queue_url
    end
    
    it "destroys the queue_item" do
      queue_item = Fabricate(:queue_item, user: current_user)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(0)
    end

    it "normalizes the remaining queue items" do
      queue_item1 = Fabricate(:queue_item, user: current_user, position: 1)
      queue_item2 = Fabricate(:queue_item, user: current_user, position: 2)
      delete :destroy, id: queue_item1.id
      expect(queue_item2.reload.position).to eq(1)
    end

    it "does not destroy the queue item of different user" do
      alice      = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: alice)
      delete :destroy, id: queue_item.id
      expect(QueueItem.count).to eq(1)
    end    

    it_behaves_like "require sign in" do
      let(:action) { delete :destroy, id: 1 }
    end
  end

  describe "PATCH update_queue" do
    context "with valid data" do
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2) }

      it "redirects to my_queue_url" do
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 1}, {id: queue_item2.id, position: 2}]
        expect(response).to redirect_to my_queue_url
      end

      context "positions" do
        it "updates positions of all queue_items" do
          patch :update_queue, queue_items: [{id: queue_item1.id, position: 2}, {id:queue_item2.id, position: 1}]
          expect(current_user.queue_items).to eq([queue_item2, queue_item1])
        end

        it "normalizes the queue items" do
          patch :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id:queue_item2.id, position: 2}]
          expect(current_user.queue_items.map(&:position)).to eq([1, 2])
        end
      end

      context "ratings" do
        let(:video)      { Fabricate(:video) }
        let(:queue_item) { Fabricate(:queue_item, user: current_user, video: video) }
        subject { Review.first.rating }

        it "updates review with ratings and body" do
          review      = Fabricate(:review, user: current_user, video: video, rating: 1)
          patch :update_queue, queue_items: [{ id: queue_item.id, position: 1, rating: 5 }]
          expect(subject).to eq(5)
        end

        it "creates a review without body but with rating" do
          patch :update_queue, queue_items: [{ id: queue_item.id, position: 1,rating: 4 }]
          expect(subject).to eq(4)
        end

        it "does not create a review if rating is blank" do
          patch :update_queue, queue_items: [{ id: queue_item.id, position: 1, rating: "" }]
          expect(subject).to eq(nil)
        end
      end    
    end

    context "with invalid data" do
      let(:queue_item1) { Fabricate(:queue_item, user: current_user, position: 1) }
      let(:queue_item2) { Fabricate(:queue_item, user: current_user, position: 2) }
      
      it "redirects to my_queue_url if params are missing" do
        patch :update_queue
        expect(response).to redirect_to my_queue_url
      end

      it "redirects to my_queue_url" do
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id:queue_item2.id, position: 2 }]
        expect(response).to redirect_to my_queue_url
      end

      it "provides an error flash message" do
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 3.5}, {id:queue_item2.id, position: 2}]
        expect(flash[:danger]).to be_present
      end

      it "does not update any queue_item unless position is an integer" do
        patch :update_queue, queue_items: [{id: queue_item1.id, position: 3}, {id:queue_item2.id, position: 2.2}]
        expect(queue_item1.reload.position).to eq(1)
      end

      it "does not update queue items for any other user" do
        bob        = Fabricate(:user)
        queue_item = Fabricate(:queue_item, user: bob, position: 1)
        patch :update_queue, queue_items: [{id: queue_item.id, position: 3}]
        expect(queue_item.reload.position).to eq(1)
      end
    end

    it_behaves_like "require sign in" do
      let(:action) { patch :update_queue }
    end
  end
end
