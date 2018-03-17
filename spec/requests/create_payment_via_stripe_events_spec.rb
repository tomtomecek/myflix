require 'spec_helper'

describe "Create payments via stripe events" do
  describe "charge.succeeded" do
    let(:event) do
      {
        "id" => "evt_15HXSxAqLMYq45GOcgBBDJRz",
        "created" => 1420451283,
        "livemode" => false,
        "type" => "charge.succeeded",
        "data" => {
          "object" => {
            "id" => "ch_15HXSxAqLMYq45GOreetEOzh",
            "object" => "charge",
            "created" => 1420451283,
            "livemode" => false,
            "paid" => true,
            "amount" => 999,
            "currency" => "usd",
            "refunded" => false,
            "captured" => true,
            "card" => {
              "id" => "card_15HXSvAqLMYq45GOph1DmnqB",
              "object" => "card",
              "last4" => "4242",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 1,
              "exp_year" => 2017,
              "fingerprint" => "YUjxXc5h8LOAv7gw",
              "country" => "US",
              "name" => nil,
              "address_line1" => nil,
              "address_line2" => nil,
              "address_city" => nil,
              "address_state" => nil,
              "address_zip" => nil,
              "address_country" => nil,
              "cvc_check" => "pass",
              "address_line1_check" => nil,
              "address_zip_check" => nil,
              "dynamic_last4" => nil,
              "customer" => "cus_5SSNx8l0y9biED"
            },
            "balance_transaction" => "txn_15HXSxAqLMYq45GO0QdJrHPV",
            "failure_message" => nil,
            "failure_code" => nil,
            "amount_refunded" => 0,
            "customer" => "cus_5SSNx8l0y9biED",
            "invoice" => "in_15HXSxAqLMYq45GOMOVFNOka",
            "description" => nil,
            "dispute" => nil,
            "metadata" => {
            },
            "statement_descriptor" => nil,
            "fraud_details" => {
            },
            "receipt_email" => nil,
            "receipt_number" => nil,
            "shipping" => nil,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_15HXSxAqLMYq45GOreetEOzh/refunds",
              "data" => []
            }
          }
        },
        "object" => "event",
        "pending_webhooks" => 3,
        "request" => "iar_5SSNmPdH09h3c9",
        "api_version" => "2014-12-22"
      }
    end
    let(:alice) { Fabricate(:user) }
    before do
      Subscription.create(user: alice, customer_id: "cus_5SSNx8l0y9biED")
      post "/stripe_events", event
    end

    it "creates a payment", :vcr do
      expect(Payment.count).to eq(1)
    end

    it "creates a payment under the user", :vcr do
      expect(Payment.first.user).to eq(alice)
    end

    it "creates a payment with amount", :vcr do
      expect(Payment.first.amount).to eq(999)
    end

    it "creates a payment with charge id", :vcr do      
      expect(Payment.first.charge_id).to eq("ch_15HXSxAqLMYq45GOreetEOzh")
    end
  end
end
