require 'spec_helper'

describe StripeWrapper do
  describe ".set_api_key" do
    it "sets stripe API key correctly" do
      stripe_api_key = ENV['STRIPE_API_KEY']
      expect(StripeWrapper.set_api_key).to eq(stripe_api_key)
    end
  end

  describe StripeWrapper::Charge do
    let(:token) do
      Stripe::Token.create(
        card: {
          number: card_number,
          cvc: "123",
          exp_month: 03,
          exp_year: 2018
        }
      ).id
    end
    before { StripeWrapper.set_api_key }

    describe ".create", :vcr do
      context "with valid card" do
        let(:card_number) { "4242424242424242" }

        it "makes a successfull charge" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response.charge.amount).to eq(999)
          expect(response.charge.currency).to eq("usd")
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

    describe "#successfull?", :vcr do
      context "with valid card" do
        let(:card_number) { "4242424242424242" }
        
        it "returns true when status is success" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response.successfull?).to be true
        end
      end

      context "with invalid card" do
        let(:card_number) { "4000000000000002" }
        
        it "returns false when status is not success" do
          response = StripeWrapper::Charge.create(amount: 999, card: token)
          expect(response.successfull?).to be false
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