require 'spec_helper'

describe ReviewsController do
  
  describe "POST create" do
    let(:user) { Fabricate(:user) }
    let(:video) { Fabricate(:video) }
    
    context "signed in" do
      before { session[:user_id] = user.id }

      context "review record valid" do
        before do
          post :create, 
            video_id: video.id, 
            review: Fabricate.attributes_for(:review, user: user, video: video)
        end

        it { expect(assigns(:video)).to eq(video) }
        it { expect(Review.count).to    eq(1) }      
        it { expect(response).to        redirect_to video }
      end

      it "review record invalid" do
        post :create, 
          video_id: video.id, 
          review: Fabricate.attributes_for(:review, body: "")
        expect(response).to render_template 'videos/show'
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