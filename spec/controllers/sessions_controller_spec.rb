require 'spec_helper'

describe SessionsController do

  describe "GET new" do
    it "redirects to home url if logged in" do
      session[:user_id] = Fabricate(:user).id

      get :new
      expect(response).to redirect_to home_url
    end

    it "renders the new template if not logged in" do
      get :new
      expect(response).to render_template :new
    end
  end

  describe "POST create" do
    let(:user) { Fabricate(:user, email: "tom@example.com") }

    it "redirects to home url on successful login" do      
      post :create, email: user.email, password: user.password
      expect(response).to redirect_to home_url
      expect(flash[:success]).to eq("You have logged in.")
    end
    it "renders the new template on fail login" do
      post :create, email: "", password: user.password
      expect(response).to render_template :new
      expect(flash[:danger]).to eq("Incorrect email or password. Please try again.")
    end
  end
  
  describe "DELETE destroy" do
    it "sets the session has to nil" do
      session[:user_id] = Fabricate(:user).id
      get :destroy
      expect(session[:user_id]).to be nil
    end
    
    it "redirects to root url" do
      get :destroy
      expect(response).to redirect_to root_url
    end
  end

end