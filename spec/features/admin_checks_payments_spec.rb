require 'spec_helper'

feature "Admin checks payments" do
  given(:alice) do
    Fabricate(:user, email: "alice@example.com", fullname: "Alice Doe")
  end
  given(:admin) { Fabricate(:admin) }
  background do
    payment = Fabricate(:payment, user: alice)
  end

  scenario "admin can see payments" do
    sign_in(admin)
    visit admin_payments_path
    expect_to_see "$9.99"
    expect_to_see "Alice Doe"
    expect_to_see "alice@example.com"
  end

  scenario "user can not see payments" do
    sign_in(alice)
    visit admin_payments_path
    expect_to_not_see "$9.99"
    expect_to_not_see "Alice Wang"
    expect_to_see "Restricted area."
  end
end