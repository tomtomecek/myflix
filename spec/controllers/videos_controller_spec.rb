require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  let(:review) { Fabricate.build(:review) }
    
  describe "GET show" do
    context "signed in" do
      before do
        session[:user_id] = Fabricate(:user).id
        get :show, id: video
      end

      it "sets @video" do
        expect(assigns(:video)).to eq(video)
      end
      
      it "sets @reviews" do
        review1 = Fabricate(:review, video: video)
        review2 = Fabricate(:review, video: video)
        expect(assigns(:reviews)).to match_array([review1, review2])
      end

      it "sets @review" do
        expect(assigns(:review)).to be_new_record
        expect(assigns(:review)).to be_instance_of(Review)
      end
    end

 
    it "redirects to the root url for unauthenticated users" do
      get :show, id: video
      expect(response).to redirect_to root_url
    end
  end

  describe "GET search" do      
    it "sets the @result variable for authenticated users" do
      session[:user_id] = Fabricate(:user).id
      get :search, query: video.title
      expect(assigns(:result)).to eq([video])
    end

    it "redirects to the root url for unauthenticated users" do
      get :search        
      expect(response).to redirect_to root_url
    end
  end
end