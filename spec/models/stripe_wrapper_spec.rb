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
end

def set_stripe_token_for_card(card_number)
  Stripe::Token.create(
    card: {
      number: card_number,
      cvc: "123",
      exp_month: 03,
      exp_year: 2018
    }
  ).id
end