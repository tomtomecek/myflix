require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  before { session[:user_id] = Fabricate(:user).id }
  
  describe "GET show" do
    it "sets the @video variable" do      
      get :show, id: video
      expect(assigns(:video)).to eq(video)
    end

    it "renders the show template" do      
      get :show, id: video
      expect(response).to render_template :show
    end
  end

  describe "GET search" do
    it "sets the @result variable" do
      get :search, query: video.title
      expect(assigns(:result)).to eq([video])
    end

    it "renders the search template" do
      get :search
      expect(response).to render_template :search
    end
  end
end