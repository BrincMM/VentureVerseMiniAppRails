# frozen_string_literal: true

class StripeCustomersController < ApplicationController
  def index
    # Just show the search form
  end

  def search
    @email = params[:email]&.strip
    @stripe_customer = nil
    @subscriptions = nil
    @local_user = nil
    
    if @email.blank?
      flash.now[:alert] = 'Please enter an email address'
      render :index
      return
    end

    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      Rails.logger.info "🔍 Searching Stripe customers for email: #{@email}"
      
      # Search Stripe customers by email
      customers = Stripe::Customer.list(email: @email, limit: 10)
      
      Rails.logger.info "📊 Stripe API response: Found #{customers.data.count} customers"
      
      if customers.data.any?
        # Log all customers found
        customers.data.each_with_index do |customer, index|
          Rails.logger.info "👤 Customer #{index + 1}: #{customer.id} (#{customer.email}) - Created: #{Time.at(customer.created)}"
        end
        
        # Select the most recent customer (by creation date)
        stripe_customer = customers.data.max_by(&:created)
        Rails.logger.info "✅ Selected most recent customer: #{stripe_customer.id} (created: #{Time.at(stripe_customer.created)})"
        
        # Get subscriptions for this customer - use Stripe API directly
        Rails.logger.info "🔄 Fetching subscriptions for customer: #{stripe_customer.id}"
        subscriptions = Stripe::Subscription.list(customer: stripe_customer.id)
        Rails.logger.info "📋 Found #{subscriptions.data.count} subscriptions"
        
        # Only store minimal data needed for display
        @stripe_customer_data = {
          id: stripe_customer.id,
          email: stripe_customer.email,
          name: stripe_customer.name,
          created: stripe_customer.created
        }
        
        @subscription_data = subscriptions.data.map do |sub|
          item = sub.items.data.first
          {
            id: sub.id,
            status: sub.status,
            current_period_start: item&.current_period_start,
            current_period_end: item&.current_period_end,
            price_id: item&.price&.id
          }
        end
        
        @all_customers_data = customers.data.map do |customer|
          {
            id: customer.id,
            email: customer.email,
            name: customer.name,
            created: customer.created
          }
        end
        
        # Check if user exists in local database
        @local_user = User.find_by(email: @email)
        Rails.logger.info "💾 Local user found: #{@local_user ? 'Yes' : 'No'}"
        
        flash.now[:notice] = "Found #{customers.data.count} customer(s) in Stripe (showing most recent)"
      else
        Rails.logger.warn "❌ No customers found for email: #{@email}"
        flash.now[:alert] = "No customers found with email: #{@email}"
      end
      
    rescue Stripe::StripeError => e
      Rails.logger.error "💥 Stripe API error: #{e.message}"
      flash.now[:alert] = "Stripe error: #{e.message}"
    rescue => e
      Rails.logger.error "💥 General error: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      flash.now[:alert] = "Error: #{e.message}"
    end
    
    render :index
  end

  def sync
    customer_id = params[:customer_id]
    Rails.logger.info "🔄 Starting sync for customer: #{customer_id}"
    
    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      # Get customer from Stripe
      Rails.logger.info "📞 Retrieving customer from Stripe: #{customer_id}"
      stripe_customer = Stripe::Customer.retrieve(customer_id)
      Rails.logger.info "👤 Retrieved customer: #{stripe_customer.email}"
      
      # Find or create local user
      local_user = User.find_by(email: stripe_customer.email)
      Rails.logger.info "🔍 Local user lookup: #{local_user ? 'Found' : 'Not found'}"
      
      unless local_user
        Rails.logger.warn "❌ No local user found for email: #{stripe_customer.email}"
        redirect_to stripe_customers_path, alert: "No local user found with email: #{stripe_customer.email}"
        return
      end
      
      # Create or update stripe_info
      if local_user.stripe_info
        Rails.logger.info "🔄 Updating existing stripe_info"
        local_user.stripe_info.update!(stripe_customer_id: customer_id)
      else
        Rails.logger.info "✨ Creating new stripe_info"
        local_user.create_stripe_info!(stripe_customer_id: customer_id)
      end
      
      # Sync subscription information
      Rails.logger.info "🔄 Running StripeSubscriptionService sync"
      service = StripeSubscriptionService.new(local_user)
      sync_result = service.sync_subscription_info
      Rails.logger.info "📊 Sync result: #{sync_result}"
      
      if sync_result
        Rails.logger.info "✅ Sync completed successfully for #{local_user.email}"
        redirect_to stripe_customers_path, notice: "Successfully synced subscription data for #{local_user.email}"
      else
        Rails.logger.warn "❌ Sync failed for #{local_user.email}"
        redirect_to stripe_customers_path, alert: "Failed to sync subscription data"
      end
      
    rescue Stripe::StripeError => e
      Rails.logger.error "💥 Stripe API error during sync: #{e.message}"
      redirect_to stripe_customers_path, alert: "Stripe error: #{e.message}"
    rescue => e
      Rails.logger.error "💥 General error during sync: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      redirect_to stripe_customers_path, alert: "Error: #{e.message}"
    end
  end

  private

  def search_params
    params.permit(:email)
  end
end
