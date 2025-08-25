# frozen_string_literal: true

class StripeCheckoutService
  # Price IDs for different plans
  PRICE_IDS = {
    'launch' => 'price_1RxNPYRjEJjLBLjEbYn0WhbN',  # Launch Plan
    'fly' => 'price_1RxNUZRjEJjLBLjE0dHA6ODF',     # Fly Plan
    'soar' => 'price_1RxNWtRjEJjLBLjE6e2WnCjF'     # Soar Plan
  }.freeze

  def initialize(user, plan_name)
    @user = user
    @plan_name = plan_name.to_s.downcase
    @price_id = PRICE_IDS[@plan_name]
    
    # Set Stripe API key
    Stripe.api_key = Rails.application.credentials.strip[:secret_key]
  end

  def create_checkout_session(success_url: nil, cancel_url: nil)
    raise ArgumentError, "Invalid plan: #{@plan_name}" unless @price_id

    # Create or retrieve Stripe customer
    stripe_customer = find_or_create_stripe_customer

    # Create checkout session
    session = Stripe::Checkout::Session.create({
      customer: stripe_customer.id,
      payment_method_types: ['card'],
      line_items: [{
        price: @price_id,
        quantity: 1,
      }],
      mode: 'subscription',
      success_url: success_url || default_success_url,
      cancel_url: cancel_url || default_cancel_url,
      metadata: {
        user_id: @user.id,
        plan_name: @plan_name
      }
    })

    session
  rescue Stripe::StripeError => e
    Rails.logger.error "Stripe error creating checkout session: #{e.message}"
    raise e
  end

  def self.available_plans
    PRICE_IDS.keys
  end

  private

  def find_or_create_stripe_customer
    if @user.stripe_info&.stripe_customer_id
      # Retrieve existing customer
      Stripe::Customer.retrieve(@user.stripe_info.stripe_customer_id)
    else
      # Create new customer
      customer = Stripe::Customer.create({
        email: @user.email,
        name: "#{@user.first_name} #{@user.last_name}",
        metadata: {
          user_id: @user.id
        }
      })

      # Create or update stripe_info record
      if @user.stripe_info
        @user.stripe_info.update!(stripe_customer_id: customer.id)
      else
        @user.create_stripe_info!(stripe_customer_id: customer.id)
      end

      customer
    end
  end

  def default_success_url
    # You can customize these URLs based on your frontend
    "http://localhost:3000/subscriptions?success=true"
  end

  def default_cancel_url
    # You can customize these URLs based on your frontend
    "http://localhost:3000/subscriptions?cancelled=true"
  end
end
