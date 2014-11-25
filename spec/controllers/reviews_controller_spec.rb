require 'spec_helper'

describe ReviewsController do
  describe "POST create" do
    let(:video) { Fabricate(:video) }

    context "for authenticated user" do
      let(:current_user) { Fabricate(:user) }
      before { session[:user_id] = current_user.id }

      context "with valid data" do
        before do 
          post :create, review: Fabricate.attributes_for(:review), video_id: video.id
        end

        it "redirects to video url" do
          expect(response).to redirect_to video
        end

        it "creates a review" do
          expect(Review.count).to eq(1)
        end
        
        it "creates a review under video" do
          expect(Review.first.video).to eq(video)
        end
        
        it "creates a review under video and under user" do
          expect(Review.first.user).to eq(current_user)
        end
      end

      context "with invalid data" do
        it "does not create a review" do
          post :create, review: { rating: 2 }, video_id: video.id
          expect(Review.count).to eq(0)
        end

        it "renders videos/show template" do
          post :create, review: { rating: 2 }, video_id: video.id
          expect(response).to render_template 'videos/show'
        end

        it "sets @video" do
          post :create, review: { rating: 2 }, video_id: video.id
          expect(assigns(:video)).to eq(video)
        end

        it "sets @reviews" do
          review = Fabricate(:review, video: video)
          post :create, review: { rating: 2 }, video_id: video.id
          expect(assigns(:reviews)).to match_array([review])
        end
      end
    end
    
    context "for unauthenticated user" do
      it "redirects to root url" do
        post :create, 
          review: Fabricate.attributes_for(:review, video: video), 
          video_id: video.id
        expect(response).to redirect_to root_url
      end
    end
  end 
end