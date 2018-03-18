require 'spec_helper'

describe VideosController do
  let(:video) { Fabricate(:video) }
  let(:review) { Fabricate.build(:review) }
  before { set_current_user }

  describe "GET show" do
    context "signed in" do
      before { get :show, id: video }

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

    it_behaves_like "require sign in" do
      let(:action) { get :show, id: video }
    end
  end

  describe "GET search" do
    it "sets the @result variable for authenticated users" do
      get :search, query: video.title
      expect(assigns(:result)).to eq([video])
    end

    it_behaves_like "require sign in" do
      let(:action) { get :search }
    end
  end
end
