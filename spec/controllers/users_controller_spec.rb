require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    context "valid input" do
      before { post :create, user: Fabricate.attributes_for(:user) }
    
      it "creates the user" do
        expect(User.count).to eq(1)
      end
      
      it { expect(response).to redirect_to sign_in_url }
    end

    context "invalid input" do
      before { post :create, user: { email: "" } }

      it "does not create a user if invalid input" do
        expect(User.count).to eq(0)
      end
      
      it "sets errors on @user" do
        expect(assigns(:user).errors.any?).to be true
      end

      it { expect(response).to render_template :new }
    end
  end  
end