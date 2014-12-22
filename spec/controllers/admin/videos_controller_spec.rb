require 'spec_helper'

describe Admin::VideosController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
      let(:action) { get :new }
    end

    context "when user is not an admin" do
      it "redirects to home page" do
        alice = Fabricate(:user, admin: false)
        set_current_user(alice)
        get :new
        expect(response).to redirect_to home_url
      end

      it "sets the flash danger" do
        alice = Fabricate(:user, admin: false)
        set_current_user(alice)
        get :new
        expect(flash[:danger]).to be_present
      end
    end

    context "when user is an admin" do
      it "sets the @video" do
        admin = Fabricate(:user, admin: true)
        set_current_user(admin)
        get :new
        expect(assigns(:video)).to be_instance_of Video
      end
    end

  end
end