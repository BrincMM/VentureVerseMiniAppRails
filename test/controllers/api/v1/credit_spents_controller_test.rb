require "test_helper"

module Api
  module V1
    class CreditSpentsControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:user_one)
      end

      test "should reject request without token" do
        post '/api/v1/credit_spents',
             params: {
               cost: 0.5,
               type: "app_usage",
               user_id: @user.id,
               estimation: true
             }
        assert_response :unauthorized
      end

      test "should reject request with invalid token" do
        post '/api/v1/credit_spents',
             headers: { 'Authorization' => 'Bearer invalid_token' },
             params: {
               cost: 0.5,
               type: "app_usage",
               user_id: @user.id,
               estimation: true
             }
        assert_response :unauthorized
      end

      test "calculate with estimation returns credit amount" do
        post_with_token '/api/v1/credit_spents',
             params: {
               cost: 0.5,
               type: "app_usage",
               user_id: @user.id,
               estimation: true
             }

        assert_response :success
        
        response_body = JSON.parse(response.body)
        assert_equal true, response_body["success"]
        assert_equal "Credit amount calculated successfully", response_body["message"]
        assert_equal 85, response_body["data"]["credit_required"]
      end

      test "calculate without estimation creates credit spent record" do
        assert_difference "CreditSpent.count", 1 do
          post_with_token '/api/v1/credit_spents',
               params: {
                 cost: 1.0,
                 type: "content_procurement",
                 user_id: @user.id,
                 estimation: false
               }
        end

        assert_response :created
        
        response_body = JSON.parse(response.body)
        assert_equal true, response_body["success"]
        assert_equal "Credit spent record created successfully", response_body["message"]
        assert_equal 170.0, response_body["data"]["credits"]
        
        record = response_body["data"]["credit_spent_record"]
        assert_equal @user.id, record["user_id"]
        assert_equal 1.0, record["cost_in_usd"]
        assert_equal 170.0, record["credits"]
        assert_equal "content_procurement", record["spend_type"]
        assert_not_nil record["timestamp"]
      end

      test "calculate with invalid cost returns error" do
        post_with_token '/api/v1/credit_spents',
             params: {
               cost: 0,
               type: "app_usage",
               user_id: @user.id
             }

        assert_response :unprocessable_entity
        
        response_body = JSON.parse(response.body)
        assert_equal false, response_body["success"]
        assert_equal "Invalid parameters", response_body["message"]
        assert_includes response_body["errors"], "Cost must be greater than 0"
      end

      test "calculate with invalid type returns error" do
        post_with_token '/api/v1/credit_spents',
             params: {
               cost: 1.0,
               type: "invalid_type",
               user_id: @user.id
             }

        assert_response :unprocessable_entity
        
        response_body = JSON.parse(response.body)
        assert_equal false, response_body["success"]
        assert_equal "Invalid parameters", response_body["message"]
        assert_includes response_body["errors"].first, "Type must be one of:"
      end

      test "calculate with non-existent user returns error" do
        post_with_token '/api/v1/credit_spents',
             params: {
               cost: 1.0,
               type: "app_usage",
               user_id: 0
             }

        assert_response :not_found
        
        response_body = JSON.parse(response.body)
        assert_equal false, response_body["success"]
        assert_equal "User not found", response_body["message"]
        assert_includes response_body["errors"], "User does not exist"
      end

      test "calculate with missing parameters returns error" do
        post_with_token '/api/v1/credit_spents',
             params: {}

        assert_response :unprocessable_entity
        
        response_body = JSON.parse(response.body)
        assert_equal false, response_body["success"]
        assert_equal "Invalid parameters", response_body["message"]
        assert_includes response_body["errors"], "Cost, type and user ID are required"
      end
    end
  end
end
