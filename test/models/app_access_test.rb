require "test_helper"

class AppAccessTest < ActiveSupport::TestCase
  setup do
    @app_access = app_accesses(:access_one)
    @app = apps(:app_one)
    @user = users(:user_one)
  end

  test "valid app access" do
    assert @app_access.valid?
  end

  test "uniqueness validation" do
    duplicate_access = AppAccess.new(app: @app, user: @user)
    assert_not duplicate_access.valid?
    assert_includes duplicate_access.errors[:user_id], "already has access to this app"
  end

  test "scopes" do
    assert_includes AppAccess.by_app(@app.id), @app_access
    assert_includes AppAccess.by_user(@user.id), @app_access
  end

  test "associations" do
    assert_equal @app, @app_access.app
    assert_equal @user, @app_access.user
  end
end 