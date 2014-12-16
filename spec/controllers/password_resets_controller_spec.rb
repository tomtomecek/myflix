require 'spec_helper'

describe PasswordResetsController do

  describe "POST create" do
    context "with valid email" do
      it "redirects to confirm password reset url" do
        post :create, email: "alice@example.com"
      end

      it "sends out the email" do
        
      end
      it "sends the email to the requested email address"
      it "creates a token"
    end

    context "with invalid email" do
      it "renders the new template" do
      end
      it "does not send out the email" do
      end
      it "does not create a token" do
      end
    end
  end  

end