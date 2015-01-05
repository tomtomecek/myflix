require 'spec_helper'

describe "Deactive customers account" do
  describe "charge.failed" do
    let(:event) do
      {
        "id" => "evt_15HkDlAqLMYq45GOu2R5r8Yl",
        "created" => 1420500313,
        "livemode" => false,
        "type" => "charge.failed",
        "data" => {
          "object" => {
            "id" => "ch_15HkDlAqLMYq45GOQV8tMVkx",
            "object" => "charge",
            "created" => 1420500313,
            "livemode" => false,
            "paid" => false,
            "amount" => 999,
            "currency" => "usd",
            "refunded" => false,
            "captured" => false,
            "card" => {
              "id" => "card_15HkCyAqLMYq45GOtWcVtcPQ",
              "object" => "card",
              "last4" => "0341",
              "brand" => "Visa",
              "funding" => "credit",
              "exp_month" => 4,
              "exp_year" => 2016,
              "fingerprint" => "qgbCZcZGc0FfrB3q",
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
              "customer" => "cus_5SY1vbiVNTqc5v"
            },
            "balance_transaction" => nil,
            "failure_message" => "Your card was declined.",
            "failure_code" => "card_declined",
            "amount_refunded" => 0,
            "customer" => "cus_5SY1vbiVNTqc5v",
            "invoice" => nil,
            "description" => "payment fail",
            "dispute" => nil,
            "metadata" => {},
            "statement_descriptor" => nil,
            "fraud_details" => {},
            "receipt_email" => nil,
            "receipt_number" => nil,
            "shipping" => nil,
            "refunds" => {
              "object" => "list",
              "total_count" => 0,
              "has_more" => false,
              "url" => "/v1/charges/ch_15HkDlAqLMYq45GOQV8tMVkx/refunds",
              "data" => []
            }
          }
        },
        "object" => "event",
        "pending_webhooks" => 4,
        "request" => "iar_5SfYZQmNSA1Ve6",
        "api_version" => "2014-12-22"
      }
    end

    it "deactivates users account", :vcr do
      alice = Fabricate(:user, activated: true)
      Subscription.create(user: alice, customer_id: "cus_5SY1vbiVNTqc5v")
      post "/stripe_events", event
      expect(alice.reload).not_to be_activated
    end
  end
end