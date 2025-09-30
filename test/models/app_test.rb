require "test_helper"

class AppTest < ActiveSupport::TestCase
  setup do
    @app = apps(:app_one)
    @user = users(:user_one)
    @user_without_access = users(:user_without_tier)
  end

  test "valid app" do
    assert @app.valid?
  end

  test "app name validation" do
    @app.name = nil
    assert_not @app.valid?
    assert_includes @app.errors[:name], "can't be blank"

    @app.name = apps(:app_two).name
    assert_not @app.valid?
    assert_includes @app.errors[:name], "has already been taken"
  end

  test "url validation" do
    @app.link = "invalid-url"
    assert_not @app.valid?
    assert_includes @app.errors[:link], "must be a valid URL"

    @app.link = "https://valid-url.com"
    assert @app.valid?
  end

  test "scopes" do
    assert_includes App.by_category(@app.category_id), @app
    assert_includes App.by_sector(@app.sector_id), @app
    assert_includes App.accessible_by_user(@user.id), @app
  end

  test "access management" do
    assert @app.accessible_by?(@user)
    assert_not @app.accessible_by?(@user_without_access)

    @app.grant_access_to(@user_without_access)
    assert @app.accessible_by?(@user_without_access)

    @app.revoke_access_from(@user_without_access)
    assert_not @app.accessible_by?(@user_without_access)
  end

  test "associations" do
    assert_not_empty @app.app_activities
    assert_not_empty @app.app_accesses
    assert_not_empty @app.users
  end
end 