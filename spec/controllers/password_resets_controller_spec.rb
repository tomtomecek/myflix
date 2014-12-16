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

      it "generates unique token" do
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

  describe "GET edit" do
    context "with valid token" do
      it "sets the @user" do
        alice = Fabricate(:user, token: SecureRandom.urlsafe_base64)
        get :edit, token: alice.token
        expect(assigns(:user)).to eq(alice)
      end
    end

    context "with invalid token" do
      it "redirects to new password reset url" do
        expired_token = SecureRandom.urlsafe_base64
        alice = Fabricate(:user, token: nil)
        get :edit, token: expired_token
        expect(response).to redirect_to password_reset_url
      end
    end
  end

  describe "PATCH update" do
    context "with valid details" do
      let(:alice) { Fabricate(:user, token: SecureRandom.urlsafe_base64) }
      before do
        patch :update, token: alice.token, user: { password: "new-password" }
      end

      it "redirects to sign in url" do
        expect(response).to redirect_to sign_in_url
      end

      it "sets the flash succes" do
        expect(flash[:success]).to be_present
      end

      it "resets password" do
        expect(alice.reload.authenticate("new-password")).to eq(alice)
      end

      it "sets the token to nil" do
        expect(alice.reload.token).to be nil
      end
    end

    context "with invalid details" do
      let(:alice) { Fabricate(:user, token: SecureRandom.urlsafe_base64) }
      before { patch :update, token: alice.token, user: { password: "12" } }

      it "renders the :edit tempalte" do
        expect(response).to render_template :edit
      end

      it "sets the @user" do
        expect(assigns(:user)).to eq(alice)
      end
    end

    context "invalid token" do
      it "redirects to new password reset url for invalid token" do
        expired_token = SecureRandom.urlsafe_base64
        alice = Fabricate(:user, token: nil)
        patch :update, token: expired_token, password: "new-password"
        expect(response).to redirect_to password_reset_url
      end
    end
  end
end