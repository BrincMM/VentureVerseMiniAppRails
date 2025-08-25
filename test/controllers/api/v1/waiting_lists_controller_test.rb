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

      test "should create new waiting list entry with email type" do
        assert_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "new@example.com",
            subscribe_type: "email"
          }
        end

        assert_response :created
        json_response = JSON.parse(@response.body)
        assert_equal true, json_response["success"]
        assert_equal "Successfully subscribed to waiting list", json_response["message"]
        assert_equal "new@example.com", json_response.dig("data", "email")
        assert_equal "email", json_response.dig("data", "subscribe_type")
      end

      test "should create new waiting list entry with google type" do
        assert_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "google@example.com",
            subscribe_type: "google"
          }
        end

        assert_response :created
        json_response = JSON.parse(@response.body)
        assert_equal true, json_response["success"]
        assert_equal "Successfully subscribed to waiting list", json_response["message"]
        assert_equal "google@example.com", json_response.dig("data", "email")
        assert_equal "google", json_response.dig("data", "subscribe_type")
      end

      test "should default to email type when subscribe_type not provided" do
        assert_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "default@example.com"
          }
        end

        assert_response :created
        json_response = JSON.parse(@response.body)
        assert_equal "email", json_response.dig("data", "subscribe_type")
      end

      test "should not create duplicate entry for existing email" do
        existing_email = waiting_lists(:waiting_list_one).email
        
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: existing_email,
            subscribe_type: "google"
          }
        end

        assert_response :ok
        json_response = JSON.parse(@response.body)
        assert_equal true, json_response["success"]
        assert_equal "Successfully subscribed to waiting list", json_response["message"]
        assert_equal existing_email, json_response.dig("data", "email")
        assert_equal "email", json_response.dig("data", "subscribe_type") # Should return existing record's type
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
            email: "invalid_email",
            subscribe_type: "email"
          }
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(@response.body)
        assert_equal false, json_response["success"]
        assert_equal "Failed to subscribe to waiting list", json_response["message"]
        assert_includes json_response["errors"], "Email is invalid"
      end

      test "should reject request with invalid subscribe_type" do
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "test@example.com",
            subscribe_type: "invalid_type"
          }
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(@response.body)
        assert_equal false, json_response["success"]
        assert_equal "Invalid parameters", json_response["message"]
        assert_includes json_response["errors"], "Subscribe type must be one of: email, google"
      end

      test "should reject request with blank email" do
        assert_no_difference("WaitingList.count") do
          post_with_token api_v1_waiting_lists_path, params: {
            email: "",
            subscribe_type: "email"
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
