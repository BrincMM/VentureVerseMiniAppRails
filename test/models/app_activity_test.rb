require "test_helper"

class AppActivityTest < ActiveSupport::TestCase
  setup do
    @activity = app_activities(:activity_one)
  end

  test "valid activity" do
    assert @activity.valid?
  end

  test "activity type validation" do
    @activity.activity_type = nil
    assert_not @activity.valid?
    assert_includes @activity.errors[:activity_type], "can't be blank"
  end

  test "timestamp validation" do
    @activity.timestamp = nil
    assert_not @activity.valid?
    assert_includes @activity.errors[:timestamp], "can't be blank"
  end

  test "activity type enum values" do
    assert_equal 0, AppActivity.activity_types[:app_usage]
    assert_equal 1, AppActivity.activity_types[:content_procurement]
    assert_equal 2, AppActivity.activity_types[:perks_procurement]
    assert_equal 3, AppActivity.activity_types[:nft_procurement]
  end

  test "scopes" do
    app = apps(:app_one)
    user = users(:user_one)
    
    assert_includes AppActivity.by_app(app.id), @activity
    assert_includes AppActivity.by_user(user.id), @activity
    assert_includes AppActivity.by_type(:app_usage), @activity
    assert_includes AppActivity.recent, @activity
    
    start_date = 1.day.ago
    end_date = 1.day.from_now
    assert_includes AppActivity.in_date_range(start_date, end_date), @activity
  end

  test "associations" do
    assert_equal apps(:app_one), @activity.app
    assert_equal users(:user_one), @activity.user
  end
end 