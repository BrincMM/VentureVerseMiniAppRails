require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user_one)
    @user_two = users(:user_two)
    @user_without_tier = users(:user_without_tier)
  end

  test "valid user" do
    assert @user.valid?, "User should be valid, but got errors: #{@user.errors.full_messages.join(', ')}"
  end

  test "email validation" do
    @user.email = nil
    assert_not @user.valid?
    assert_includes @user.errors[:email], "can't be blank"

    @user.email = "invalid_email"
    assert_not @user.valid?
    assert_includes @user.errors[:email], "is invalid"

    @user.email = @user_two.email
    assert_not @user.valid?
    assert_includes @user.errors[:email], "has already been taken"
  end

  test "first name validation" do
    @user.first_name = nil
    assert_not @user.valid?
    assert_includes @user.errors[:first_name], "can't be blank"
  end

  test "nick name uniqueness" do
    @user.nick_name = @user_two.nick_name
    assert_not @user.valid?
    assert_includes @user.errors[:nick_name], "has already been taken"
  end

  test "credit balance validation" do
    @user.monthly_credit_balance = -1
    assert_not @user.valid?
    assert_includes @user.errors[:monthly_credit_balance], "must be greater than or equal to 0"

    @user.top_up_credit_balance = -1
    assert_not @user.valid?
    assert_includes @user.errors[:top_up_credit_balance], "must be greater than or equal to 0"
  end

  test "role methods" do
    assert @user.founder?
    assert_not @user.mentor?
    assert_not @user.investor?

    assert @user_two.mentor?
    assert @user_two.investor?
    assert_not @user_two.founder?
  end

  test "add and remove role" do
    @user.add_role(:mentor)
    assert @user.mentor?

    @user.remove_role(:mentor)
    assert_not @user.mentor?
  end

  test "current tier name" do
    assert_equal "Basic", @user.current_tier_name
    assert_equal "Pro", @user_two.current_tier_name
    assert_equal "Free", @user_without_tier.current_tier_name
  end

  test "app access methods" do
    app = apps(:app_one)
    new_app = apps(:app_two)

    assert @user.has_access_to?(app)
    assert_not @user_without_tier.has_access_to?(app)

    @user_without_tier.grant_access_to(app)
    assert @user_without_tier.has_access_to?(app)

    @user_without_tier.revoke_access_to(app)
    assert_not @user_without_tier.has_access_to?(app)
  end

  test "record activity" do
    app = apps(:app_one)
    activity = @user.record_activity(app, :app_usage, "test meta")
    
    assert_equal app, activity.app
    assert_equal "app_usage", activity.activity_type
    assert_equal "test meta", activity.app_meta
    assert_equal @user, activity.user
  end

  test "stripe related methods" do
    assert @user.stripe_customer?
    assert @user.active_subscription?
    assert_equal 30, @user.days_until_next_billing

    assert @user_two.stripe_customer?
    assert @user_two.active_subscription?
    assert_equal 7, @user_two.days_until_next_billing

    assert_not @user_without_tier.stripe_customer?
    assert_not @user_without_tier.active_subscription?
    assert_nil @user_without_tier.days_until_next_billing
  end
end 