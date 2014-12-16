require 'spec_helper'

describe PasswordResetsController do

  describe "POST create" do
    context "with valid email" do
      after { ActionMailer::Base.deliveries.clear }
      
      it "redirects to confirm password reset url" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(response).to redirect_to confirm_password_reset_url
      end

      it "creates a token" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(alice.reload.token).not_to be nil
      end

      it "sends out the email" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries).not_to be_empty
      end

      it "sends the email to the requested email address" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: alice.email
        expect(ActionMailer::Base.deliveries.last.to).to eq([alice.email])
      end            
    end

    context "with invalid email" do
      it "renders the new template" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: "wrong@email.com"
        expect(response).to render_template :new
      end

      it "does not create a token" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: "wrong@email.com"
        expect(alice.reload.token).to be nil
      end

      it "does not send out the email" do
        alice = Fabricate(:user, email: "alice@example.com")
        post :create, email: "wrong@email.com"
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end
end