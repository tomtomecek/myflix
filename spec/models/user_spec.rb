require 'spec_helper'

describe User do
  it { should have_many(:reviews) }
  it { should have_many(:queue_items).order(:position) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email).case_insensitive }
  it { should validate_presence_of(:password) }
  it { should validate_presence_of(:fullname) }

  it "creates user with downcased email" do
    user = User.create(email: "TEST@EXAMPLE.COM", password: "123", fullname: "TEST USER")
    expect(user.reload.email).to eq("test@example.com")
  end

end