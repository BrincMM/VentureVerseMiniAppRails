require "test_helper"

module Api
  module V1
    class LogInHistoriesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:user_one)
        @log_in_history = log_in_histories(:one)
      end

      test "should reject request without token" do
        get api_v1_log_in_histories_url, as: :json
        assert_response :unauthorized
      end

      test "should reject request with invalid token" do
        get api_v1_log_in_histories_url,
            headers: { 'Authorization' => 'Bearer invalid_token' },
            as: :json
        assert_response :unauthorized
      end

      test "should create log in history" do
        metadata = { "browser" => "Chrome", "ip" => "127.0.0.1" }
        
        assert_difference("LogInHistory.count") do
          post_with_token api_v1_log_in_histories_url, params: {
            log_in_history: {
              user_id: @user.id,
              metadata: metadata.to_json
            }
          }, as: :json
        end

        assert_response :success
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "Login history created successfully", json_response["message"]
        
        history_data = json_response["data"]["log_in_history"]
        assert_equal @user.id, history_data["user_id"]
        assert_equal metadata, JSON.parse(history_data["metadata"])
      end

      test "should not create log in history with invalid metadata" do
        post_with_token api_v1_log_in_histories_url, params: {
          log_in_history: {
            user_id: @user.id,
            metadata: "invalid json"
          }
        }, as: :json

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Failed to create login history", json_response["message"]
        assert_includes json_response["errors"], "Metadata must be valid JSON"
      end

      test "should get list of login histories" do
        get_with_token api_v1_log_in_histories_url, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "Login histories retrieved successfully", json_response["message"]
        assert_equal 2, json_response["data"]["total_count"]
        assert_equal 1, json_response["data"]["total_pages"]
        assert_equal 1, json_response["data"]["current_page"]
        assert_equal 10, json_response["data"]["per_page"]
        assert_equal false, json_response["data"]["has_next"]
        assert_not_nil json_response["data"]["log_in_histories"]
      end

      test "should filter login histories by user_id" do
        get_with_token api_v1_log_in_histories_url, params: { user_id: @user.id }, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        
        histories = json_response["data"]["log_in_histories"]
        histories.each do |history|
          assert_equal @user.id, history["user_id"]
        end
      end

      test "should filter login histories by date range" do
        get_with_token api_v1_log_in_histories_url, params: {
          start_date: 1.day.ago.iso8601,
          end_date: 1.day.from_now.iso8601
        }, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 2, json_response["data"]["total_count"]
      end

      test "should return error for invalid date format" do
        get_with_token api_v1_log_in_histories_url, params: {
          start_date: "invalid-date",
          end_date: "invalid-date"
        }, as: :json
        
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Invalid date format", json_response["message"]
        assert_includes json_response["errors"], "Start date and end date must be valid dates"
      end

      test "should return error for invalid pagination parameters" do
        get_with_token api_v1_log_in_histories_url, params: { per_page: 0 }, as: :json
        
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Invalid parameters", json_response["message"]
        assert_includes json_response["errors"], "Per page must be between 1 and 100"
      end
    end
  end
end