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
    
    context "without invitation token" do
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

    context "with invitation token" do
      context "with valid token" do
        let(:pete) { Fabricate(:user) }
        let(:invitation) do
          Fabricate(:invitation,
                     sender: pete,
                     recipient_email: "kelly@example.com",
                     token: SecureRandom.urlsafe_base64)
        end

        it "creates the recipient following invitation sender" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
          kelly = User.find_by(email: invitation.recipient_email)
          expect(pete.follows?(kelly)).to be true
        end

        it "creates the recipient being followed by the sender" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token
          kelly = User.find_by(email: invitation.recipient_email)
          expect(kelly.follows?(pete)).to be true
        end

        it "expires invitation token" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: invitation.token          
          expect(Invitation.first.token).to be nil
        end
      end

      context "with invalid token" do
        let(:pete) { Fabricate(:user) }
        let(:invitation) do
          Fabricate(:invitation,
                     sender: pete,
                     recipient_email: "kelly@example.com",
                     token: SecureRandom.urlsafe_base64)
        end

        it "creates the recipient not following invitation sender" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: "no match"
          kelly = User.find_by(email: invitation.recipient_email)
          expect(pete.leading_relationships.map(&:follower)).to eq([])
        end

        it "creates the recipient not being followed by the sender" do
          post :create, user: Fabricate.attributes_for(:user, email: invitation.recipient_email), invitation_token: "no match"
          kelly = User.find_by(email: invitation.recipient_email)
          expect(kelly.leading_relationships.map(&:follower)).to eq([])
        end
      end
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