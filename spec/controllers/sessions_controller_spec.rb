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
    let(:user) { Fabricate(:user, email: "tom@example.com") }

    context "with valid credentials" do
      before { post :create, email: user.email, password: user.password }
      
      it "sets user id to session" do
        expect(session[:user_id]).to eq(user.id)
      end

      it "redirects to home url" do
        expect(response).to redirect_to home_url
      end
      
      it "sets flash success" do
        expect(flash[:success].present?).to be true
      end
    end
    
    context "with invalid credentials" do
      before { post :create, email: "", password: user.password }

      it "does not set user id to session" do
        expect(session[:user_id]).to be nil
      end

      it "renders :new template" do
        expect(response).to render_template :new
      end

      it "sets flash danger" do
        expect(flash[:danger].present?).to be true
      end
    end
  end
  
  describe "DELETE destroy" do
    before do
      session[:user_id] = Fabricate(:user).id
      get :destroy
    end

    it "sets the session to nil" do
      expect(session[:user_id]).to be nil
    end

    it "redirects to root url" do
      expect(response).to redirect_to root_url
    end

    it "sets flash success" do
      expect(flash[:success].present?).to be true
    end
  end
end