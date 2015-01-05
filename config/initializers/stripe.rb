Stripe.api_key = ENV['STRIPE_API_KEY']

StripeEvent.configure do |events|
  events.subscribe 'charge.succeeded' do |event|
    charge = event.data.object
    user = Subscription.find_by(customer_id: charge.customer).user
    Payment.create(
      user: user,
      charge_id: charge.id,
      amount: charge.amount
    )
  end

  events.subscribe 'charge.failed' do |event|
    charge = event.data.object
    user = Subscription.find_by(customer_id: charge.customer).user
    user.deactivate!
  end
end