require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    let(:token) { set_stripe_token }   

    describe ".create", :vcr do
      context "with valid card" do
        let(:card_number) { "4242424242424242" }

        it "makes a successfull charge" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response).to be_successfull
        end
      end

      context "with invalid card" do
        let(:card_number) { "4000000000000002" }

        it "does not make a successfull charge" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response.status).to eq(:error)
          expect(response).not_to be_successfull
        end
      end
    end

    describe "#error_message", :vcr do
      let(:card_number) { "4000000000000002" }

      it "returns an error message" do
        response = StripeWrapper::Charge.create(amount: 999, card: token)
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end

def set_stripe_token
  Stripe::Token.create(
    card: {
      number: card_number,
      cvc: "123",
      exp_month: 03,
      exp_year: 2018
    }
  ).id
end