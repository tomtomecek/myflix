require 'spec_helper'

describe Admin::VideosController do
  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it_behaves_like "require admin" do
      let(:action) { get :new }
    end

    context "when admin" do
      it "sets the @video" do
        set_current_admin
        get :new
        expect(assigns(:video)).to be_instance_of Video
        expect(assigns(:video)).to be_new_record
      end
    end
  end

  describe "POST create" do
    it_behaves_like "require sign in" do
      let(:action) { post :create }
    end

    it_behaves_like "require admin" do
      let(:action) { post :create }
    end

    context "when admin" do
      context "with valid inputs" do
        let(:tv_shows) { Fabricate(:category) }
        before do
          set_current_admin
          post :create, video: {
            title: "Futurama",
            description: "Kevins fav tv show",
            category_id: tv_shows.id,
            video_url: "http://xxx.com"
          }
        end

        it "redirects to new admin video" do
          expect(response).to redirect_to new_admin_video_url
        end

        it "creates the video" do
          expect(tv_shows.videos.count).to eq(1)
        end

        it "sets the flash success" do
          expect(flash[:success]).to be_present
        end
      end

      context "with invalid inputs" do
        let(:tv_shows) { Fabricate(:category) }
        before do
          set_current_admin
          post :create, video: {
            title: "",
            description: "",
            category_id: tv_shows.id,
            video_url: "http://xxx.com"
          }
        end

        it "renders the :new template" do
          expect(response).to render_template :new
        end

        it "does not create the video" do
          expect(Video.count).to eq(0)
        end

        it "sets the @video" do
          expect(assigns(:video)).to be_instance_of Video
          expect(assigns(:video)).to be_new_record
        end

        it "sets the errors on @video" do
          expect(assigns(:video).errors).to be_present
        end
      end
    end
  end
end
