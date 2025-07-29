class StripeInfo < ApplicationRecord
  belongs_to :user

  validates :stripe_customer_id, presence: true, uniqueness: true
  validates :subscription_status, inclusion: { 
    in: %w[trialing active past_due canceled unpaid], 
    allow_nil: true 
  }

  # Scopes
  scope :active_subscriptions, -> { where(subscription_status: 'active') }
  scope :trialing_subscriptions, -> { where(subscription_status: 'trialing') }
  scope :past_due_subscriptions, -> { where(subscription_status: 'past_due') }
  scope :upcoming_renewals, ->(days = 7) {
    where(subscription_status: ['active', 'trialing'])
    .where('next_subscription_time <= ?', days.days.from_now)
  }

  def active?
    subscription_status.in?(['active', 'trialing'])
  end

  def canceled?
    subscription_status == 'canceled'
  end

  def past_due?
    subscription_status == 'past_due'
  end

  def days_until_next_billing
    return nil unless next_subscription_time
    ((next_subscription_time - Time.current) / 1.day).round
  end
end 