require "test_helper"

class TierTest < ActiveSupport::TestCase
  setup do
    @tier = tiers(:tier_one)
  end

  test "valid tier" do
    assert @tier.valid?
  end

  test "tier name validation" do
    @tier.name = nil
    assert_not @tier.valid?
    assert_includes @tier.errors[:name], "can't be blank"

    @tier.name = tiers(:tier_two).name
    assert_not @tier.valid?
    assert_includes @tier.errors[:name], "has already been taken"
  end

  test "stripe price id validation" do
    @tier.stripe_price_id = nil
    assert_not @tier.valid?
    assert_includes @tier.errors[:stripe_price_id], "can't be blank"

    @tier.stripe_price_id = tiers(:tier_two).stripe_price_id
    assert_not @tier.valid?
    assert_includes @tier.errors[:stripe_price_id], "has already been taken"
  end

  test "active validation" do
    @tier.active = nil
    assert_not @tier.valid?
    assert_includes @tier.errors[:active], "is not included in the list"
  end

  test "active scope" do
    active_tiers = Tier.active
    assert_includes active_tiers, tiers(:tier_one)
    assert_includes active_tiers, tiers(:tier_two)
    assert_not_includes active_tiers, tiers(:tier_inactive)
  end

  test "has many users association" do
    assert_includes @tier.users, users(:user_one)
  end
end 