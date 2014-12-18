require 'spec_helper'

describe InvitationsController do

  describe "GET new" do
    it_behaves_like "require_sign_in" do
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
    before { set_current_user(pete) }
    after { ActionMailer::Base.deliveries.clear }
    
    it_behaves_like "require_sign_in" do
      let(:action) { post :create, invitation: Fabricate.attributes_for(:invitation) }
    end

    context "with valid email" do
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

    context "with invalid email" do
      before do
        post :create, invitation: { 
          recipient_name: "Kelly",
          recipient_email: "kelly@example",
          message: "Please join this really cool site!" }
      end
      
      it "renders the :new template" do
        expect(response).to render_template :new
      end

      it "does not create the invitation" do
        expect(Invitation.count).to eq(0)
      end

      it "does not send out the email" do        
        expect(ActionMailer::Base.deliveries).to be_empty
      end

      it "sets the @invitation" do
        expect(assigns(:invitation)).to be_instance_of(Invitation)
      end
    end
  end
end