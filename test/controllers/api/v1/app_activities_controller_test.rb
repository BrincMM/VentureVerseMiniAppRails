require "test_helper"

module Api
  module V1
    class AppActivitiesControllerTest < ActionDispatch::IntegrationTest
      setup do
        @user = users(:user_one)
        @app = apps(:app_one)
        @activity = app_activities(:activity_one)
      end

      test "should reject request without token" do
        get api_v1_app_activities_url, as: :json
        assert_response :unauthorized
      end

      test "should reject request with invalid token" do
        get api_v1_app_activities_url,
            headers: { 'Authorization' => 'Bearer invalid_token' },
            as: :json
        assert_response :unauthorized
      end

      test "should create app activity" do
        assert_difference("AppActivity.count") do
          post_with_token api_v1_app_activities_url, params: {
            app_activity: {
              user_id: @user.id,
              app_id: @app.id,
              activity_type: "app_usage",
              app_meta: { duration: "10m" }
            }
          }, as: :json
        end

        assert_response :success
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "Activity created successfully", json_response["message"]
        
        activity_data = json_response["data"]["app_activity"]
        assert_equal @user.id, activity_data["user_id"]
        assert_equal @app.id, activity_data["app_id"]
        assert_equal "app_usage", activity_data["activity_type"]
        assert_equal({ "duration" => "10m" }, JSON.parse(activity_data["app_meta"]))
      end

      test "should not create app activity with invalid parameters" do
        post_with_token api_v1_app_activities_url, params: {
          app_activity: {
            user_id: @user.id,
            app_id: @app.id,
            activity_type: "invalid_type"
          }
        }, as: :json

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Failed to create activity", json_response["message"]
        assert_includes json_response["errors"], "'invalid_type' is not a valid activity_type"
      end

      test "should get list of activities" do
        get_with_token api_v1_app_activities_url, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "Activities retrieved successfully", json_response["message"]
        assert_equal 2, json_response["data"]["total_count"]
        assert_equal 1, json_response["data"]["total_pages"]
        assert_equal 1, json_response["data"]["current_page"]
        assert_equal 10, json_response["data"]["per_page"]
        assert_equal false, json_response["data"]["has_next"]
        assert_not_nil json_response["data"]["activities"]
      end

      test "should filter activities by type" do
        get_with_token api_v1_app_activities_url, params: { activity_type: "app_usage" }, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        
        assert_equal 1, json_response["data"]["total_count"]
        activities = json_response["data"]["activities"]
        assert_equal "app_usage", activities.first["activity_type"]
      end

      test "should filter activities by app_id" do
        get_with_token api_v1_app_activities_url, params: { app_id: @app.id }, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        
        activities = json_response["data"]["activities"]
        activities.each do |activity|
          assert_equal @app.id, activity["app_id"]
        end
      end

      test "should filter activities by date range" do
        get_with_token api_v1_app_activities_url, params: {
          start_date: 1.day.ago.iso8601,
          end_date: 1.day.from_now.iso8601
        }, as: :json
        
        assert_response :success
        json_response = JSON.parse(response.body)
        assert_equal 2, json_response["data"]["total_count"]
      end

      test "should return error for invalid date format" do
        get_with_token api_v1_app_activities_url, params: {
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
        get_with_token api_v1_app_activities_url, params: { per_page: 0 }, as: :json
        
        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Invalid parameters", json_response["message"]
        assert_includes json_response["errors"], "Per page must be between 1 and 100"
      end
    end
  end
end