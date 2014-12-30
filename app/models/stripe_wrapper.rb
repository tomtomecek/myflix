module StripeWrapper
  class Charge
    attr_reader :charge, :status
    def initialize(charge, status)
      @charge = charge
      @status = status
    end

    def self.create(options={})
      begin
        charge = Stripe::Charge.create(
          amount:      options[:amount],
          currency:    "usd",
          card:        options[:card],
          description: options[:description]
        )
        new(charge, :success)
      rescue Stripe::CardError => e
        new(e, :error)
      end
    end

    def successfull?
      status == :success
    end

    def error_message
      charge.message
    end
  end
end