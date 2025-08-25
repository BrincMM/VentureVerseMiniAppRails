require "test_helper"

module Api
  module V1
    class WaitingListsControllerTest < ActionDispatch::IntegrationTest
      test "should reject request without token" do
        post api_v1_waiting_lists_path, params: {
          email: "test@example.com"
        }
        assert_response :unauthorized
      end

      test "should reject request with invalid token" do
        post api_v1_waiting_lists_path,
            headers: { 'Authorization' => 'Bearer invalid_token' },
            params: {
              email: "test@example.com"
            }
        assert_response :unauthorized
      end

      test "should create new waiting list entry" do
        assert_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "new@example.com"
          }
        end

        assert_response :created
        json_response = JSON.parse(@response.body)
        assert_equal true, json_response["success"]
        assert_equal "Successfully subscribed to waiting list", json_response["message"]
        assert_equal "new@example.com", json_response.dig("data", "email")
      end

      test "should not create duplicate entry for existing email" do
        existing_email = waiting_lists(:waiting_list_one).email
        
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: existing_email
          }
        end

        assert_response :ok
        json_response = JSON.parse(@response.body)
        assert_equal true, json_response["success"]
        assert_equal "Successfully subscribed to waiting list", json_response["message"]
        assert_equal existing_email, json_response.dig("data", "email")
      end

      test "should reject request without email" do
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {}
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(@response.body)
        assert_equal false, json_response["success"]
        assert_equal "Invalid parameters", json_response["message"]
        assert_includes json_response["errors"], "Email is required"
      end

      test "should reject request with invalid email format" do
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "invalid_email"
          }
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(@response.body)
        assert_equal false, json_response["success"]
        assert_equal "Failed to subscribe to waiting list", json_response["message"]
        assert_includes json_response["errors"], "Email is invalid"
      end

      test "should reject request with blank email" do
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: ""
          }
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(@response.body)
        assert_equal false, json_response["success"]
        assert_equal "Invalid parameters", json_response["message"]
        assert_includes json_response["errors"], "Email is required"
      end
    end
  end
end
