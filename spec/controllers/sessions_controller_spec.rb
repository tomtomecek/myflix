require 'spec_helper'

describe SessionsController do
  describe "GET new" do    
    it "renders :new template for unauthorized user" do
      get :new
      expect(response).to render_template :new
    end

    it "redirects to home url for authorized user" do
      session[:user_id] = Fabricate(:user).id
      get :new
      expect(response).to redirect_to home_url
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, admin: false) }

    context "with valid credentials" do
      it "sets the session" do
        post :create, email: user.email, password: user.password
        expect(session[:user_id]).to eq user.id
      end

      it "sets the flash success" do
        post :create, email: user.email, password: user.password
        expect(flash[:success]).to be_present
      end

      context "when user is an admin" do
        it "redirects admin to new admin video url" do
          admin = Fabricate(:user, admin: true)
          post :create, email: admin.email, password: admin.password
          expect(response).to redirect_to new_admin_video_url
        end
      end

      context "when user is a non-admin" do
        it "redirects non-admin to home url" do
          post :create, email: user.email, password: user.password
          expect(response).to redirect_to home_url
        end
      end
    end

    context "with invalid credentials" do
      before { post :create, email: "", password: "no match" }
      it { expect(session[:user_id]).to be nil }
      it { expect(response).to render_template :new }
      it { expect(flash[:danger]).to be_present }
    end
  end

  describe "DELETE destroy" do
    before { set_current_user; get :destroy }
    it { expect(session[:user_id]).to be nil }
    it { expect(response).to redirect_to root_url }
    it { expect(flash[:success]).to be_present }
  end
end