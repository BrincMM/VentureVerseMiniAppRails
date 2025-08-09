# frozen_string_literal: true

class StripeSubscriptionService
  def initialize(user)
    @user = user
    @stripe_info = user.stripe_info
  end

  def next_subscription_time
    return nil unless @stripe_info&.stripe_customer_id

    begin
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

  private

  def fetch_active_subscription
    customer = Stripe::Customer.retrieve(@stripe_info.stripe_customer_id)
    subscriptions = customer.subscriptions.list(limit: 1, status: 'active')
    subscriptions.data.first
  end

  def update_subscription_info(subscription)
    @stripe_info.update(
      subscription_id: subscription.id,
      subscription_status: subscription.status,
      next_subscription_time: Time.at(subscription.current_period_end)
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