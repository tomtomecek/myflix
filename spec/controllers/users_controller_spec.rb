require 'spec_helper'

describe UsersController do

  describe "GET new" do
    it "sets the @user" do
      get :new
      expect(assigns(:user)).to be_instance_of(User)
    end
  end

  describe "POST create" do
    after { ActionMailer::Base.deliveries.clear }
    
    context "valid input" do    
      it "creates the user" do
        post :create, user: Fabricate.attributes_for(:user)
        expect(User.count).to eq(1)
      end
      
      it "redirects to sign_in_url" do
        post :create, user: Fabricate.attributes_for(:user)
        is_expected.to redirect_to sign_in_url
      end

      context "email sending" do
        it "sends out the email" do
          post :create, user: Fabricate.attributes_for(:user)
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end
        
        it "sends to the right recipient" do
          post :create, user: Fabricate.attributes_for(:user, email: "alice@example.com")
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq(["alice@example.com"])
        end

        it "has the right content" do
          post :create, user: Fabricate.attributes_for(:user, email: "alice@example.com")
          message = ActionMailer::Base.deliveries.last          
          expect(message.body.encoded).to include("Welcome")
        end
      end
    end

    context "invalid input" do
      before { post :create, user: { email: "" } }

      it "does not create a user if invalid input" do
        expect(User.count).to eq(0)
      end
      
      it "sets errors on @user" do
        expect(assigns(:user).errors.any?).to be true
      end

      it "does not send the email" do
        expect(ActionMailer::Base.deliveries).to be_empty
      end
      it { is_expected.to render_template :new }
    end
  end

  describe "GET show" do
    it "sets the @user" do
      alice = Fabricate(:user)
      get :show, id: alice.id
      expect(assigns(:user)).to eq(alice)
    end
  end
end