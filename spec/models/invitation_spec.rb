require 'spec_helper'

describe Invitation do
  it { is_expected.to belong_to(:sender).class_name("User") }
  it { is_expected.to validate_presence_of(:recipient_name) }
  it { is_expected.to validate_presence_of(:message) }
  
  it "allows email format" do
    should allow_value('user@example.com', 'TEST.A@abc.in',
      'user.ab.dot@test.ds.info', 'foo-bar2@baz2.com').for(:recipient_email)
  end

  it "does not allow email format" do
    should_not allow_value('foo@bar', "'z\\foo@ex.com", 'foobar.com',
      'foo@bar.c', 'foo..bar@ex.com', '>!?#@ex.com', 'mel,bour@ne.aus')
      .for(:recipient_email)
  end

  it "creates invitation with a random unique token" do
    pete = Fabricate(:user)
    petes_invitation = Fabricate(:invitation, sender: pete)
    expect(petes_invitation.reload.token).not_to be nil
  end
end