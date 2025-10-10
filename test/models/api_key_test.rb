require "test_helper"

class ApiKeyTest < ActiveSupport::TestCase
  test "should have valid fixtures" do
    assert api_keys(:one).valid?
    assert api_keys(:two).valid?
    assert api_keys(:expired).valid?
  end

  test "should require app_id" do
    api_key = ApiKey.new(api_key: "test_key_123")
    assert_not api_key.valid?
    assert_includes api_key.errors[:app_id], "can't be blank"
  end

  test "should require api_key" do
    api_key = ApiKey.new(app: apps(:app_one))
    # Need to skip callback and set to nil after validation
    api_key.define_singleton_method(:generate_api_key) {}
    api_key.api_key = nil
    assert_not api_key.valid?
    assert_includes api_key.errors[:api_key], "can't be blank"
  end

  test "should require unique api_key" do
    api_key = ApiKey.new(
      app: apps(:app_one),
      api_key: api_keys(:one).api_key
    )
    assert_not api_key.valid?
    assert_includes api_key.errors[:api_key], "has already been taken"
  end

  test "should auto-generate api_key on create" do
    api_key = ApiKey.create!(app: apps(:app_one))
    assert api_key.api_key.present?
    assert_equal 64, api_key.api_key.length # SecureRandom.hex(32) generates 64 characters
  end

  test "should have default status active" do
    api_key = ApiKey.new(app: apps(:app_one))
    assert_equal "active", api_key.status
  end

  test "should have default rate limits" do
    api_key = ApiKey.new(app: apps(:app_one))
    api_key.save!
    assert_equal 100, api_key.rate_limit_per_minute
    assert_equal 10000, api_key.rate_limit_per_day
  end

  test "should have status enum" do
    api_key = api_keys(:one)
    assert api_key.active?
    
    api_key.revoked!
    api_key.reload
    assert api_key.revoked?
    
    api_key.expired!
    api_key.reload
    assert api_key.expired?
  end

  test "should check if expired by date" do
    api_key = api_keys(:expired)
    assert api_key.expired_by_date?
    
    api_key_active = api_keys(:one)
    assert_not api_key_active.expired_by_date?
  end

  test "should check if valid for use" do
    # Active and not expired
    api_key = api_keys(:one)
    assert api_key.valid_for_use?
    
    # Revoked
    revoked_key = api_keys(:two)
    assert_not revoked_key.valid_for_use?
    
    # Expired
    expired_key = api_keys(:expired)
    assert_not expired_key.valid_for_use?
  end

  test "should revoke api key" do
    api_key = api_keys(:one)
    assert api_key.active?
    
    api_key.revoke!
    assert api_key.revoked?
  end

  test "should record usage" do
    api_key = api_keys(:one)
    original_time = api_key.last_used_at
    
    sleep 0.01 # Small delay to ensure time difference
    api_key.record_usage!
    
    assert api_key.last_used_at > original_time
  end

  test "should belong to app" do
    api_key = api_keys(:one)
    assert_respond_to api_key, :app
    assert_equal apps(:app_one), api_key.app
  end

  test "should validate rate limits are positive" do
    api_key = ApiKey.new(
      app: apps(:app_one),
      rate_limit_per_minute: -1,
      rate_limit_per_day: -100
    )
    assert_not api_key.valid?
    assert_includes api_key.errors[:rate_limit_per_minute], "must be greater than 0"
    assert_includes api_key.errors[:rate_limit_per_day], "must be greater than 0"
  end
end
