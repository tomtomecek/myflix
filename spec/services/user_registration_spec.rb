require 'spec_helper'

describe UserRegistration do

  describe "#register" do
    context "with valid person data and valid card" do
      let(:charge) { double(:charge, successfull?: true) }
      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)
      end
      after { ActionMailer::Base.deliveries.clear }

      it "create the user" do
        user = Fabricate.build(:user)
        UserRegistration.new(user, "stripe_token", nil).register
        expect(User.count).to eq(1)
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
          let(:kelly) { Fabricate.build(:user, email: invitation.recipient_email) }

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
          let(:kelly) { Fabricate.build(:user, email: invitation.recipient_email) }

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
        it "sends out the email" do
          user = Fabricate.build(:user, email: "alice@example.com")
          UserRegistration.new(user, "stripe_token", nil).register
          expect(ActionMailer::Base.deliveries).not_to be_empty
        end

        it "sends to the right recipient" do
          user = Fabricate.build(:user, email: "alice@example.com")
          UserRegistration.new(user, "stripe_token", nil).register
          message = ActionMailer::Base.deliveries.last
          expect(message.to).to eq(["alice@example.com"])
        end

        it "has the right content" do
          user = Fabricate.build(:user, email: "alice@example.com")
          UserRegistration.new(user, "stripe_token", nil).register
          message = ActionMailer::Base.deliveries.last
          expect(message.body.encoded).to include("Welcome")
        end
      end
    end

    context "with valid person data and declined card" do
      let(:charge) do
        double(:charge, successfull?: false, error_message: "Your card was declined.")
      end

      before do
        StripeWrapper::Charge.should_receive(:create).and_return(charge)        
      end
      
      it "does not create a new user record" do        
        user = Fabricate.build(:user, email: "alice@example.com")
        UserRegistration.new(user, "stripe_token", nil).register
        expect(User.count).to eq(0)
      end
    end

    context "with invalid person data" do
      it "does not create a user" do
        user = Fabricate.build(:user, email: "")
        UserRegistration.new(user, "stripe_token", nil).register
        expect(User.count).to eq(0)
      end

      it "does not charge card" do
        StripeWrapper::Charge.should_not_receive(:create)
        user = Fabricate.build(:user, email: "")
        UserRegistration.new(user, "stripe_token", nil).register
      end

      it "does not send the email" do
        user = Fabricate.build(:user, email: "")
        UserRegistration.new(user, "stripe_token", nil).register
        expect(ActionMailer::Base.deliveries).to be_empty
      end
    end
  end

  describe "#successfull?" do
    it "returns true if registration was successfull." do
      charge = double("charge", successfull?: true)
      StripeWrapper::Charge.should_receive(:create).and_return(charge)
      user = Fabricate.build(:user)
      reg = UserRegistration.new(user, "stripe_token", nil).register
      expect(reg).to be_successfull
      ActionMailer::Base.deliveries.clear
    end

    it "returns false if registration failed." do
      charge = double("charge", successfull?: false, error_message: "an error message")
      StripeWrapper::Charge.should_receive(:create).and_return(charge)
      user = Fabricate.build(:user)
      reg = UserRegistration.new(user, "stripe_token", nil).register
      expect(reg).not_to be_successfull
    end
  end
end