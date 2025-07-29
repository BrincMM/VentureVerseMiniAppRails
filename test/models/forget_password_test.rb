require "test_helper"

class ForgetPasswordTest < ActiveSupport::TestCase
  setup do
    @forget_password = forget_passwords(:forget_password_one)
  end

  test "valid forget password" do
    assert @forget_password.valid?
  end

  test "email validation" do
    @forget_password.email = nil
    assert_not @forget_password.valid?
    assert_includes @forget_password.errors[:email], "can't be blank"

    @forget_password.email = "invalid_email"
    assert_not @forget_password.valid?
    assert_includes @forget_password.errors[:email], "is invalid"
  end

  test "code validation" do
    @forget_password.code = nil
    assert_not @forget_password.valid?
    assert_includes @forget_password.errors[:code], "can't be blank"

    @forget_password.code = 99999  # Less than 100000
    assert_not @forget_password.valid?
    assert_includes @forget_password.errors[:code], "must be greater than or equal to 100000"

    @forget_password.code = 1000000  # Greater than 999999
    assert_not @forget_password.valid?
    assert_includes @forget_password.errors[:code], "must be less than or equal to 999999"
  end

  test "scopes" do
    assert_includes ForgetPassword.for_email(@forget_password.email), @forget_password
    assert_includes ForgetPassword.with_code(@forget_password.code), @forget_password
    assert_includes ForgetPassword.recent, @forget_password
  end

  test "generate code" do
    code = ForgetPassword.generate_code
    assert code.between?(100000, 999999)
  end

  test "expired?" do
    @forget_password.created_at = 11.minutes.ago
    assert @forget_password.expired?

    @forget_password.created_at = 9.minutes.ago
    assert_not @forget_password.expired?

    @forget_password.created_at = 11.minutes.ago
    assert_not @forget_password.expired?(15)
  end

  test "valid_code?" do
    assert @forget_password.valid_code?(@forget_password.code)
    assert_not @forget_password.valid_code?(111111)

    @forget_password.created_at = 11.minutes.ago
    assert_not @forget_password.valid_code?(@forget_password.code)
  end
end 