require "test_helper"

class CreditTopupTest < ActiveSupport::TestCase
  setup do
    @credit_topup = credit_topups(:topup_one)
  end

  test "valid credit topup" do
    assert @credit_topup.valid?
  end

  test "timestamp validation" do
    @credit_topup.timestamp = nil
    assert_not @credit_topup.valid?
    assert_includes @credit_topup.errors[:timestamp], "can't be blank"
  end

  test "credit topup validation" do
    @credit_topup.credits = nil
    assert_not @credit_topup.valid?
    assert_includes @credit_topup.errors[:credits], "can't be blank"

    @credit_topup.credits = 0
    assert_not @credit_topup.valid?
    assert_includes @credit_topup.errors[:credits], "must be greater than 0"

    @credit_topup.credits = -1
    assert_not @credit_topup.valid?
    assert_includes @credit_topup.errors[:credits], "must be greater than 0"
  end

  test "belongs to user association" do
    assert_equal users(:user_one), @credit_topup.user
  end
end 
