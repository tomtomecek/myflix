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

      it { expect(assigns(:video)).to eq(video) }
      it { expect(assigns(:review)).to be_new_record }
      it { expect(assigns(:review)).to be_instance_of(Review)}
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