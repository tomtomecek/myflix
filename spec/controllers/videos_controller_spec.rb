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
      it { expect(response).to render_template :show }
    end

    context "not signed in" do
      it "redirects to the root url" do
        get :show, id: video
        expect(response).to redirect_to root_url
      end
    end
  end

  describe "GET search" do
    context "signed in" do
      before { session[:user_id] = Fabricate(:user).id }
      
      it "sets the @result variable" do
        get :search, query: video.title
        expect(assigns(:result)).to eq([video])
      end
      it "renders the search template" do
        get :search
        expect(response).to render_template :search
      end
    end

    context "not signed in" do
      it "redirects to the root url" do
        get :search        
        expect(response).to redirect_to root_url
      end
    end
  end
end