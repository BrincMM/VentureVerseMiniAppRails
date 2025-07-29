require "test_helper"

class StripeInfoTest < ActiveSupport::TestCase
  setup do
    @stripe_info = stripe_infos(:stripe_one)
  end

  test "valid stripe info" do
    assert @stripe_info.valid?
  end

  test "stripe customer id validation" do
    @stripe_info.stripe_customer_id = nil
    assert_not @stripe_info.valid?
    assert_includes @stripe_info.errors[:stripe_customer_id], "can't be blank"

    @stripe_info.stripe_customer_id = stripe_infos(:stripe_two).stripe_customer_id
    assert_not @stripe_info.valid?
    assert_includes @stripe_info.errors[:stripe_customer_id], "has already been taken"
  end

  test "subscription status validation" do
    @stripe_info.subscription_status = "invalid_status"
    assert_not @stripe_info.valid?
    assert_includes @stripe_info.errors[:subscription_status], "is not included in the list"

    valid_statuses = %w[trialing active past_due canceled unpaid]
    valid_statuses.each do |status|
      @stripe_info.subscription_status = status
      assert @stripe_info.valid?
    end

    @stripe_info.subscription_status = nil
    assert @stripe_info.valid?
  end

  test "scopes" do
    assert_includes StripeInfo.active_subscriptions, stripe_infos(:stripe_one)
    assert_includes StripeInfo.trialing_subscriptions, stripe_infos(:stripe_two)
    assert_not_includes StripeInfo.past_due_subscriptions, @stripe_info
  end

  test "upcoming renewals scope" do
    @stripe_info.next_subscription_time = 5.days.from_now
    @stripe_info.save!
    
    assert_includes StripeInfo.upcoming_renewals, @stripe_info
    assert_includes StripeInfo.upcoming_renewals(10), @stripe_info
    assert_not_includes StripeInfo.upcoming_renewals(3), @stripe_info
  end

  test "status check methods" do
    @stripe_info.subscription_status = "active"
    assert @stripe_info.active?
    assert_not @stripe_info.canceled?
    assert_not @stripe_info.past_due?

    @stripe_info.subscription_status = "trialing"
    assert @stripe_info.active?
    assert_not @stripe_info.canceled?
    assert_not @stripe_info.past_due?

    @stripe_info.subscription_status = "canceled"
    assert_not @stripe_info.active?
    assert @stripe_info.canceled?
    assert_not @stripe_info.past_due?

    @stripe_info.subscription_status = "past_due"
    assert_not @stripe_info.active?
    assert_not @stripe_info.canceled?
    assert @stripe_info.past_due?
  end

  test "days until next billing" do
    @stripe_info.next_subscription_time = 30.days.from_now
    assert_equal 30, @stripe_info.days_until_next_billing

    @stripe_info.next_subscription_time = nil
    assert_nil @stripe_info.days_until_next_billing
  end

  test "belongs to user association" do
    assert_equal users(:user_one), @stripe_info.user
  end
end 