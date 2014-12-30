require 'spec_helper'

feature "user registers at MyFLiX and pays with credit card", js: true, vcr: true, driver: :selenium do

  background { visit register_path }

  context "with valid user data" do
    background { fill_in_valid_user_data }

    scenario "valid card" do
      fill_in_credit_card_data_and_submit("4242424242424242")
      expect_to_see "Welcome to myFlix! You have successfully registered."
    end

    scenario "invalid card" do
      fill_in_credit_card_data_and_submit("123")
      expect_to_see "This card number looks invalid"
    end

    scenario "expired card" do
      fill_in_credit_card_data_and_submit("4000000000000069")
      expect_to_see "Your card has expired."
    end

    scenario "incorrect cvc" do
      fill_in_credit_card_data_and_submit("4000000000000127")
      expect_to_see "Your card's security code is incorrect."
    end

    scenario "processing error" do
      fill_in_credit_card_data_and_submit("4000000000000119")
      expect_to_see "An error occurred while processing your card. Try again in a little bit."
    end

    scenario "declined card" do
      fill_in_credit_card_data_and_submit("4000000000000002")
      expect_to_see "Your card was declined."
    end
  end

  context "with invalid user data" do
    background { fill_in_invalid_user_data }

    scenario "with invalid user data and valid card" do
      fill_in_credit_card_data_and_submit("4242424242424242")
      expect_to_see "Please fix the errors below."
    end

    scenario "with invalid user data and invalid card" do
      fill_in_credit_card_data_and_submit("123")
      expect_to_see "This card number looks invalid"
    end

    scenario "with invalid user data and declined card" do
      fill_in_credit_card_data_and_submit("4000000000000002")
      expect_to_see "Please fix the errors below."
    end
  end
end

def fill_in_valid_user_data
  fill_in "Email Address", with: "alice@example.com"
  fill_in "Password",      with: "password"
  fill_in "Full Name",     with: "Alice Wang"
end

def fill_in_invalid_user_data
  fill_in "Email Address", with: "alice@example.com"
end

def fill_in_credit_card_data_and_submit(card_number)
  fill_in "Credit Card Number", with: card_number
  fill_in "Security Code",      with: "123"
  select "4 - April", from: "date_month"
  select "2017", from: "date_year"
  click_button "Sign Up"
end