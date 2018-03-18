require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    describe ".create", :vcr do
      context "when valid card" do
        let(:token) { set_stripe_token_for_card("4242424242424242") }
        it "makes a successfull charge" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response).to be_successfull
        end
      end

      context "when invalid card" do
        let(:token) { set_stripe_token_for_card("4000000000000002") }
        it "does not make a successfull charge" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response).not_to be_successfull
        end

        it "returns an error message" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  describe StripeWrapper::Customer do
    describe ".create", :vcr do
      context "when valid card" do
        let(:token) { set_stripe_token_for_card("4242424242424242") }

        it "creates a customer" do
          alice = Fabricate.build(:user, email: "alice@example.com")
          response = StripeWrapper::Customer.create(
            card: token,
            email: alice.email
          )
          expect(response).to be_successfull
        end
      end

      context "when invalid card" do
        let(:token) { set_stripe_token_for_card("4000000000000002") }
        let(:alice) { Fabricate.build(:user, email: "alice@example.com") }
        
        it "does not create a customer" do
          response = StripeWrapper::Customer.create(
            card: token,
            email: alice.email
          )
          expect(response).not_to be_successfull
        end

        it "returns an error" do
          response = StripeWrapper::Customer.create(
            card: token,
            email: alice.email
          )
          expect(response.error_message).to eq("Your card was declined.")
        end
      end
    end
  end

  def set_stripe_token_for_card(card_number)
    Stripe::Token.create(
      card: {
        number: card_number,
        cvc: "123",
        exp_month: 03,
        exp_year: Time.now.year + 2
      }
    ).id
  end
end
