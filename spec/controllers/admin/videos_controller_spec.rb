require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    context "when regular user" do
      before do
        set_current_user
        get :new
      end

      it { is_expected.to redirect_to home_url }
      it { is_expected.to set_the_flash[:danger] }
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
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, video: { title: "Futurama" } }
    end

    context "when regular user" do
      let(:tv_shows) { Fabricate(:category) }
      before do
        set_current_user
        post :create, video: {
          title: "Futurama",
          description: "Kevins fav tv show",
          category_id: tv_shows.id,
          large_cover_url: "futurama_large.jpg",
          small_cover_url: "futurama.jpg"
        }
      end

      it { is_expected.to redirect_to home_url }
      it { is_expected.to set_the_flash[:danger] }
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
            large_cover_url: "futurama_large.jpg",
            small_cover_url: "futurama.jpg"
          }
        end

        it "redirects to video show" do
          expect(response).to redirect_to home_url
        end

        it "creates the video" do
          expect(Video.count).to eq(1)
        end

        it "creates the video under category" do
          expect(Video.first.category).to eq(tv_shows)
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
            large_cover_url: "futurama_large.jpg",
            small_cover_url: "futurama.jpg"
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