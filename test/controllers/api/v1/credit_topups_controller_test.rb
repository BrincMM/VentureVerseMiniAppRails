require "test_helper"

module Api
  module V1
    class CreditTopupsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:one)
        @initial_topup_balance = @user.topup_credit_balance
      end

      test "should create credit topup" do
        assert_difference("CreditTopup.count") do
          post api_v1_credit_topups_path, params: {
            user_id: @user.id,
            credits: 100.0
          }
        end

        assert_response :created
        assert_equal true, json_response["success"]
        assert_equal "Credit topup record created successfully", json_response["message"]
        
        # Check response structure
        assert_equal 100.0, json_response.dig("data", "credits")
        assert_not_nil json_response.dig("data", "credit_topup_record", "id")
        assert_equal @user.id, json_response.dig("data", "credit_topup_record", "user_id")
        assert_equal 100.0, json_response.dig("data", "credit_topup_record", "credits")
        
        # Check user data
        assert_equal @user.id, json_response.dig("data", "user", "id")
        assert_equal @user.monthly_credit_balance.to_f, json_response.dig("data", "user", "monthly_credit_balance")
        assert_equal (@initial_topup_balance + 100.0), json_response.dig("data", "user", "topup_credit_balance")
        assert_not_nil json_response.dig("data", "user", "remaining_credit_ratio")

        # Verify database changes
        @user.reload
        assert_equal (@initial_topup_balance + 100.0), @user.topup_credit_balance
      end

      test "should not create credit topup with invalid credits" do
        assert_no_difference("CreditTopup.count") do
          post api_v1_credit_topups_path, params: {
            user_id: @user.id,
            credits: -10.0
          }
        end

        assert_response :unprocessable_entity
        assert_equal false, json_response["success"]
        assert_equal "Failed to create credit topup", json_response["message"]
        assert_includes json_response["errors"], "Credits must be greater than 0"
      end

      test "should not create credit topup for non-existent user" do
        assert_no_difference("CreditTopup.count") do
          post api_v1_credit_topups_path, params: {
            user_id: 999999,
            credits: 100.0
          }
        end

        assert_response :not_found
        assert_equal false, json_response["success"]
        assert_equal "User not found", json_response["message"]
        assert_includes json_response["errors"], "User not found"
      end
    end
  end
end