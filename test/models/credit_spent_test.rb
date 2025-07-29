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

  test "credit spent validation" do
    @credit_spent.credit_spent = nil
    assert_not @credit_spent.valid?
    assert_includes @credit_spent.errors[:credit_spent], "can't be blank"

    @credit_spent.credit_spent = 0
    assert_not @credit_spent.valid?
    assert_includes @credit_spent.errors[:credit_spent], "must be greater than 0"

    @credit_spent.credit_spent = -1
    assert_not @credit_spent.valid?
    assert_includes @credit_spent.errors[:credit_spent], "must be greater than 0"
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
end 