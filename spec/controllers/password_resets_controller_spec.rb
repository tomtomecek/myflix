require 'spec_helper'

describe PasswordResetsController do

  describe "POST create" do
    context "with valid email" do
      it "redirects to confirm password reset url" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(response).to redirect_to confirm_password_reset_url
      end

      it "creates a token" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(alice.attribute_present?(:token)).to be true
      end

      it "sends out the email" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends the email to the requested email address" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.to).to eq(alice.email)
      end            
    end

    context "with invalid email" do
      it "renders the new template" do
        post :create, email: "alice@example.com"
      end
      it "does not send out the email" do
        post :create, email: "alice@example.com"
      end
      it "does not create a token" do
        post :create, email: "alice@example.com"
      end
    end
  end  

end