require 'spec_helper'

describe ReviewsController do
  
  describe "POST create" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    
    context "signed in" do
      before { session[:user_id] = user.id }

      context "the review record is valid" do
        before do
          post :create, 
            video_id: video.id, 
            review: Fabricate.attributes_for(:review, user: user, video: video)
        end

        it { expect(assigns(:video)).to eq(video) }
        it { expect(Review.count).to    eq(1) }
        it { expect(response).to        redirect_to video }
      end

      context "the review record is invalid" do
        before do
          post :create, 
            video_id: video.id, 
            review: Fabricate.attributes_for(:review, body: "")
        end

        it { expect(response).to render_template 'videos/show' }
        it { expect(assigns(:review).errors.any?).to be true }
      end
    end

    context "not signed in" do
      it "redirects to the root url" do
        post :create, 
          video_id: video.id, 
          review: Fabricate.attributes_for(:review, user: user, video: video)
        expect(response).to redirect_to root_url
      end
    end
  end
  
end