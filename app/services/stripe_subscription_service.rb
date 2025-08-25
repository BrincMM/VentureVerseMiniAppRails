# frozen_string_literal: true

class StripeSubscriptionService
  def initialize(user)
    @user = user
    @stripe_info = user.stripe_info
  end

  def next_subscription_time
    return nil unless @stripe_info&.stripe_customer_id

    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      subscription = fetch_active_subscription
      return nil unless subscription

      # 更新本地数据库中的订阅信息
      update_subscription_info(subscription)

      # 返回下次订阅时间
      Time.at(subscription.current_period_end)
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error when fetching subscription: #{e.message}"
      # 如果API调用失败，返回数据库中存储的时间
      @stripe_info&.next_subscription_time
    end
  end

  def sync_subscription_info
    return false unless @stripe_info&.stripe_customer_id

    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      subscription = fetch_active_subscription
      if subscription
        update_subscription_info(subscription)
        true
      else
        # 如果没有找到活跃的订阅，清除订阅信息
        clear_subscription_info
        false
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error when syncing subscription: #{e.message}"
      false
    end
  end
  
  # Cancel user's active subscription
  def cancel_subscription
    return false unless @stripe_info&.subscription_id
    
    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      subscription = Stripe::Subscription.retrieve(@stripe_info.subscription_id)
      cancelled_subscription = subscription.cancel
      
      # Update local database
      update_subscription_info(cancelled_subscription)
      
      Rails.logger.info "Successfully cancelled subscription #{@stripe_info.subscription_id} for user #{@user.email}"
      true
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error when cancelling subscription: #{e.message}"
      false
    end
  end
  
  # Get subscription details from Stripe
  def subscription_details
    return nil unless @stripe_info&.subscription_id
    
    begin
      # Set Stripe API key
      Stripe.api_key = Rails.application.credentials.strip[:secret_key]
      
      Stripe::Subscription.retrieve(@stripe_info.subscription_id)
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error when fetching subscription details: #{e.message}"
      nil
    end
  end
  
  # Check if subscription needs renewal soon
  def needs_renewal?(days_ahead = 7)
    return false unless @stripe_info&.next_subscription_time
    
    @stripe_info.next_subscription_time <= days_ahead.days.from_now
  end

  private

  def fetch_active_subscription
    # Use Stripe API directly to get subscriptions for the customer
    subscriptions = Stripe::Subscription.list(
      customer: @stripe_info.stripe_customer_id, 
      status: 'active',
      limit: 1
    )
    subscriptions.data.first
  end

  def update_subscription_info(subscription)
    # Get the billing period from the first subscription item
    subscription_item = subscription.items.data.first
    next_billing_time = subscription_item&.current_period_end ? Time.at(subscription_item.current_period_end) : nil
    
    @stripe_info.update(
      subscription_id: subscription.id,
      subscription_status: subscription.status,
      next_subscription_time: next_billing_time
    )
  end

  def clear_subscription_info
    @stripe_info.update(
      subscription_id: nil,
      subscription_status: nil,
      next_subscription_time: nil
    )
  end
end