require "test_helper"

class UserRoleTest < ActiveSupport::TestCase
  setup do
    @user_role = user_roles(:founder_role)
    @user = users(:user_one)
  end

  test "valid user role" do
    assert @user_role.valid?
  end

  test "role presence validation" do
    @user_role.role = nil
    assert_not @user_role.valid?
    assert_includes @user_role.errors[:role], "can't be blank"
  end

  test "role uniqueness validation" do
    duplicate_role = UserRole.new(user: @user, role: :founder)
    assert_not duplicate_role.valid?
    assert_includes duplicate_role.errors[:user_id], "already has this role"
  end

  test "role enum values" do
    assert_equal 0, UserRole.roles[:founder]
    assert_equal 1, UserRole.roles[:mentor]
    assert_equal 2, UserRole.roles[:investor]
  end

  test "belongs to user association" do
    assert_equal @user, @user_role.user
  end
end 