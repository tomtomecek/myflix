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
    let(:user) { Fabricate(:user) }

    context "with valid credentials" do
      before { post :create, email: user.email, password: user.password }
      it { expect(session[:user_id]).to equal user.id }
      it { expect(response).to redirect_to home_url }
      it { expect(flash[:success]).to be_present }
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