require 'spec_helper'

describe UserRegistration do
  describe "#register" do
    context "with valid person data and valid card" do
      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(success_subscription)
      end

      it "create the user" do
        user = Fabricate.build(:user)
        UserRegistration.new(user, "stripe_token").register
        expect(User.count).to eq(1)
      end

      it "creates a subscription under user" do
        user = Fabricate.build(:user)
        UserRegistration.new(user, "stripe_token").register
        expect(user.subscriptions.count).to eq(1)
      end

      it "creates a subscription with customer_id" do
        user = Fabricate.build(:user)
        UserRegistration.new(user, "stripe_token").register
        expect(Subscription.first.customer_id).to eq("cus_123")
      end

      context "with invitation token" do
        context "valid token" do
          let(:pete) { Fabricate(:user) }
          let(:invitation) do
            Fabricate(:invitation,
              sender: pete, 
              recipient_email: "kelly@example.com",
              token: SecureRandom.urlsafe_base64
            )
          end
          let(:kelly) do
            Fabricate.build(:user, email: invitation.recipient_email)
          end

          before do
            UserRegistration.new(kelly, "stripe_token", invitation.token).register
          end

          it "creates the recipient following invitation sender" do
            expect(pete.follows?(kelly)).to be true
          end

          it "creates the recipient being followed by the sender" do
            expect(kelly.follows?(pete)).to be true
          end

          it "expires invitation token" do
            expect(Invitation.first.token).to be nil
          end
        end

        context "with invalid token" do
          let(:pete) { Fabricate(:user) }
          let(:invitation) do
            Fabricate(:invitation,
              sender: pete, 
              recipient_email: "kelly@example.com",
              token: SecureRandom.urlsafe_base64
            )
          end
          let(:kelly) do
            Fabricate.build(:user, email: invitation.recipient_email)
          end

          before do
            UserRegistration.new(kelly, "stripe_token", "no match").register
          end

          it "creates the recipient not following invitation sender" do
            expect(pete.leading_relationships.map(&:follower)).to eq([])
          end

          it "creates the recipient not being followed by the sender" do
            expect(kelly.leading_relationships.map(&:follower)).to eq([])
          end
        end
      end

      context "email sending" do
        let(:user) { Fabricate.build(:user, email: "alice@example.com") }
        before { UserRegistration.new(user, "stripe_token").register }
        subject { ActionMailer::Base.deliveries }

        it "sends out the email" do
          expect(subject).not_to be_empty
        end

        it "sends to the right recipient" do
          expect(subject.last.to).to eq(["alice@example.com"])
        end

        it "has the right content" do
          expect(subject.last.body.encoded).to include("Welcome")
        end
      end
    end

    context "with valid person data and declined card" do
      let(:user) { user = Fabricate.build(:user) }
      before do
        expect(StripeWrapper::Customer).to receive(:create).and_return(fail_subscription)
        UserRegistration.new(user, "stripe_token").register
      end

      it "does not create a new user record" do
        expect(User.count).to eq(0)
      end

      it "does not create a new subscription" do
        expect(user.subscriptions.count).to eq(0)
      end
    end

    context "with invalid person data" do
      let(:user) { User.new(email: "no match") }

      it "sets proper error message" do
        registration = UserRegistration.new(user, "stripe_token").register
        expect(registration.error_message).to eq "Invalid user details."
      end

      it "does not create a user" do
        UserRegistration.new(user, "stripe_token").register
        expect(User.count).to eq(0)
      end

      it "does not charge the card" do
        expect(StripeWrapper::Customer).to_not receive(:create)
        UserRegistration.new(user, "stripe_token").register
      end

      it "does not create a subscription" do
        expect(StripeWrapper::Customer).to_not receive(:create)
        UserRegistration.new(user, "stripe_token").register
        expect(user.subscriptions.count).to eq(0)
      end

      it "does not send the email" do
        UserRegistration.new(user, "stripe_token").register
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "#successfull?" do
    let (:user) { Fabricate.build(:user) }
    subject { UserRegistration.new(user, "stripe_token").register }

    it "returns true when registration was successfull." do
      expect(StripeWrapper::Customer).to receive(:create).and_return(success_subscription)
      expect(subject).to be_successfull
    end

    it "returns false when registration failed." do
      expect(StripeWrapper::Customer).to receive(:create).and_return(fail_subscription)
      expect(subject).not_to be_successfull
    end
  end

  def success_subscription
    subscriptions = double(:subscriptions, first: double(:first, id: "sub_456"))
    customer = double(:customer, id: "cus_123", subscriptions: subscriptions)
    double(:subscription, successfull?: true, customer: customer)
  end

  def fail_subscription
    double(:subscription, successfull?: false, error_message: "an error message")
  end
end
