require 'spec_helper'

describe ReviewsController do
  let(:user) { Fabricate(:user) }
  let(:video) { Fabricate(:video) }
  #before { session[:user_id] = user.id }

  describe "POST create" do
    
    context "creates the review if valid" do
      before do
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review, user: user, video: video)
      end

      it "creates the review under video if record is valid" do        
        expect(assigns(:video)).to eq(video)
        expect(Review.count).to eq(1)
      end      
      it { expect(response).to redirect_to video }
    end

    context "does not create the review if invalid" do
      before do 
        post :create, video_id: video.id, review: Fabricate.attributes_for(:review, body: "")
      end

      it { expect(response).to render_template 'videos/show' }
    end
        
  end
  
end