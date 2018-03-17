require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    it_behaves_like "require sign in" do
      let(:action) { get :new }
    end

    it "sets the @invitation" do
      set_current_user
      get :new
      expect(assigns(:invitation)).to be_instance_of(Invitation)
    end
  end

  describe "POST create" do
    let(:pete) { Fabricate(:user) }
    before do
      set_current_user(pete)
      ActionMailer::Base.deliveries.clear
    end

    it_behaves_like "require sign in" do
      let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
    end

    context "with valid inputs" do
      before do
        post :create, invitation: { 
          recipient_name: "Kelly",
          recipient_email: "kelly@example.com",
          message: "Please join this really cool site!" }
      end
      
      it "redirects to home url" do        
        expect(response).to redirect_to home_url
      end

      it "sets the flash success" do
        expect(flash[:success]).to be_present
      end

      it "creates the invitation" do
        expect(Invitation.count).to eq(1)
      end

      it "creates the invitation under sender" do
        expect(Invitation.first.sender).to eq(pete)
      end

      it "sends out the email to correct address" do        
        expect(ActionMailer::Base.deliveries.last.to).to eq(["kelly@example.com"])
      end
    end

    context "with invalid inputs" do
      it "renders the :new template" do
        post :create, invitation: {
          recipient_name: "Kelly",
          recipient_email: "kelly@example",
          message: "Please join this really cool site!"
        }
        expect(response).to render_template :new
      end

      it "does not create the invitation with blank name" do
        post :create, invitation: {
          recipient_name: "",
          recipient_email: "kelly@example.com",
          message: "Please join this really cool site!"
        }
        expect(Invitation.count).to eq(0)
      end

      it "does not create the invitation with wrong email" do
        post :create, invitation: {
          recipient_name: "Kelly",
          recipient_email: "kelly@example",
          message: "Please join this really cool site!"
        }
        expect(Invitation.count).to eq(0)
      end

      it "does not create the invitation with blank message" do
        post :create, invitation: {
          recipient_name: "Kelly",
          recipient_email: "kelly@example.com",
          message: ""
        }
        expect(Invitation.count).to eq(0)
      end

      it "does not send out the email" do
        post :create, invitation: { 
          recipient_name: "",
          recipient_email: "kelly@example.com",
          message: "Please join this really cool site!"
        }
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the @invitation" do
        post :create, invitation: { 
          recipient_name: "",
          recipient_email: "kelly@example.com",
          message: "Please join this really cool site!"
        }
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end

      it "sets the errors on invitation" do
        post :create, invitation: {
          recipient_name: "",
          recipient_email: "kelly@example.com",
          message: "Please join this really cool site!"
        }
        expect(assigns(:invitation).errors.any?).to be true
      end
    end
  end
end