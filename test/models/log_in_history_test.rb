require "test_helper"

class LogInHistoryTest < ActiveSupport::TestCase
  def setup
    @user = users(:user_one)
    @log_in_history = LogInHistory.new(
      user: @user,
      timestamp: Time.current,
      metadata: { browser: "Chrome", ip: "127.0.0.1" }.to_json
    )
  end

  test "should be valid" do
    assert @log_in_history.valid?
  end

  test "should require user" do
    @log_in_history.user = nil
    assert_not @log_in_history.valid?
  end

  test "should require timestamp" do
    @log_in_history.timestamp = nil
    assert_not @log_in_history.valid?
  end

  test "should require valid JSON metadata" do
    @log_in_history.metadata = "invalid json"
    assert_not @log_in_history.valid?
    assert_includes @log_in_history.errors[:metadata], "must be valid JSON"
  end

  test "should accept valid JSON metadata" do
    @log_in_history.metadata = { device: "mobile", os: "iOS" }.to_json
    assert @log_in_history.valid?
  end
end 