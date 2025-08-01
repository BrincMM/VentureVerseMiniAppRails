require "test_helper"

class CreditSpentTest < ActiveSupport::TestCase
  setup do
    @credit_spent = credit_spents(:spent_one)
  end

  test "valid credit spent" do
    assert @credit_spent.valid?
  end

  test "timestamp validation" do
    @credit_spent.timestamp = nil
    assert_not @credit_spent.valid?
    assert_includes @credit_spent.errors[:timestamp], "can't be blank"
  end


  test "spend type validation" do
    @credit_spent.spend_type = nil
    assert_not @credit_spent.valid?
    assert_includes @credit_spent.errors[:spend_type], "can't be blank"
  end

  test "spend type enum values" do
    assert_equal 0, CreditSpent.spend_types[:app_usage]
    assert_equal 1, CreditSpent.spend_types[:content_procurement]
    assert_equal 2, CreditSpent.spend_types[:perks_procurement]
    assert_equal 3, CreditSpent.spend_types[:nft_procurement]
  end

  test "belongs to user association" do
    assert_equal users(:user_one), @credit_spent.user
  end

  test "calculate_credit_amount with standard costs" do
    # Test case 1: 0.5 USD cost
    assert_equal 85, CreditSpent.calculate_credit_amount(0.5),
      "0.5 USD should require 85 credits: (0.5 * 1.7 / 0.01).ceil"

    # Test case 2: 1.0 USD cost
    assert_equal 170, CreditSpent.calculate_credit_amount(1.0),
      "1.0 USD should require 170 credits: (1.0 * 1.7 / 0.01).ceil"

    # Test case 3: 2.0 USD cost
    assert_equal 340, CreditSpent.calculate_credit_amount(2.0),
      "2.0 USD should require 340 credits: (2.0 * 1.7 / 0.01).ceil"
  end

  test "calculate_credit_amount with decimal costs" do
    # Test small decimal numbers
    assert_equal 21, CreditSpent.calculate_credit_amount(0.123),
      "0.123 USD should require 21 credits: (0.123 * 1.7 / 0.01).ceil"
    
    assert_equal 26, CreditSpent.calculate_credit_amount(0.15),
      "0.15 USD should require 26 credits: (0.15 * 1.7 / 0.01).ceil"
  end

  test "calculate_credit_amount with zero cost" do
    assert_equal 0, CreditSpent.calculate_credit_amount(0),
      "0 USD should require 0 credits"
  end

  test "calculate_credit_amount with large numbers" do
    # Test large numbers
    assert_equal 17000, CreditSpent.calculate_credit_amount(100),
      "100 USD should require 17000 credits: (100 * 1.7 / 0.01).ceil"
    
    assert_equal 170000, CreditSpent.calculate_credit_amount(1000),
      "1000 USD should require 170000 credits: (1000 * 1.7 / 0.01).ceil"
  end

  test "deducts credits from user monthly balance" do
    user = users(:user_one)
    user.update!(monthly_credit_balance: 100, topup_credit_balance: 50)

    credit_spent = CreditSpent.create!(
      user: user,
      cost_in_usd: 0.5, # Will require 85 credits
      spend_type: :app_usage
    )

    user.reload
    assert_equal 15, user.monthly_credit_balance,
      "Should deduct 85 credits from monthly balance of 100"
    assert_equal 50, user.topup_credit_balance,
      "Should not touch top up balance"
  end

  test "deducts credits from both monthly and top up balance" do
    user = users(:user_one)
    user.update!(monthly_credit_balance: 100, topup_credit_balance: 50)

    credit_spent = CreditSpent.create!(
      user: user,
      cost_in_usd: 1.0, # Will require 170 credits
      spend_type: :app_usage
    )

    user.reload
    assert_equal 0.0, user.topup_credit_balance.to_f,
      "Should use 50 credits from top up balance"
    assert_equal(-20.0, user.monthly_credit_balance.to_f,
      "Should make monthly balance negative for remaining 20 credits")
  end

  test "makes monthly balance negative when no credits available" do
    user = users(:user_one)
    user.update!(monthly_credit_balance: 0, topup_credit_balance: 0)

    credit_spent = CreditSpent.create!(
      user: user,
      cost_in_usd: 0.5, # Will require 85 credits
      spend_type: :app_usage
    )

    user.reload
    assert_equal(-85, user.monthly_credit_balance,
      "Should make monthly balance negative")
    assert_equal 0, user.topup_credit_balance,
      "Should not change top up balance"
  end
end
