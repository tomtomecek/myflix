module StripeWrapper
  class Charge
    attr_reader :response, :error_message

    def initialize(options={})
      @response = options[:response]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        charge = Stripe::Charge.create(
          amount:      options[:amount],
          currency:    "usd",
          card:        options[:card],
          description: options[:description]
        )
        new(response: charge)
      rescue Stripe::CardError => error
        new(error_message: error.message)
      end
    end

    def successfull?
      response.present?
    end
  end

  class Customer
    attr_reader :customer, :error_message
    def initialize(options={})
      @customer      = options[:customer]
      @error_message = options[:error_message]
    end

    def self.create(options={})
      begin
        response = Stripe::Customer.create(
          card: options[:card],
          plan: "myflix_standard",
          email: options[:email]
        )
        new(customer: response)
      rescue Stripe::CardError => error
        new(error_message: error.message)
      end
    end

    def successfull?
      customer.present?
    end
  end
end