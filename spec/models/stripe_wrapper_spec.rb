require 'spec_helper'

describe StripeWrapper do
  describe StripeWrapper::Charge do
    before { StripeWrapper.set_api_key }

    context "with valid card" do
      it "processes the payment", :vcr do
        card_number = "4242424242424242"
        token = Stripe::Token.create(
          card: {
            number: card_number,
            cvc: "123",
            exp_month: 03,
            exp_year: 2018
          }
        ).id
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token
        )
        expect(response).to be_successfull
      end
    end

    context "with invalid card" do
      let(:card_number) { "4000000000000002" }
      let(:token) do
        Stripe::Token.create(
          card: {
            number: card_number,
            cvc: "123",
            exp_month: 03,
            exp_year: 2016
          }
        ).id
      end

      it "does not process the payment", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token
        )
        expect(response).not_to be_successfull
      end

      it "throws an error", :vcr do
        response = StripeWrapper::Charge.create(
          amount: 999,
          card: token
        )
        expect(response.error_message).to eq("Your card was declined.")
      end
    end
  end
end