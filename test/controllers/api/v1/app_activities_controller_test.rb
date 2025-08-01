require "test_helper"

module Api
  module V1
    class AppActivitiesControllerTest < ActionDispatch::IntegrationTest
      include Devise::Test::IntegrationHelpers

      setup do
        @user = users(:user_one)
        @app = apps(:app_one)
        sign_in @user
      end

      test "should get index" do
        get api_v1_app_activities_url, as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        assert_equal true, json_response["success"]
        assert_equal "App activities retrieved successfully", json_response["message"]
        assert_not_nil json_response["data"]["app_activities"]
        assert_not_nil json_response["data"]["total_count"]
      end

      test "should get index with pagination" do
        get api_v1_app_activities_url(page: 1, per_page: 5), as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        assert_equal 5, json_response["data"]["per_page"]
        assert_equal 1, json_response["data"]["current_page"]
      end

      test "should get index with app_id filter" do
        get api_v1_app_activities_url(app_id: @app.id), as: :json
        assert_response :success
        
        json_response = JSON.parse(response.body)
        activities = json_response["data"]["app_activities"]
        assert activities.all? { |activity| activity["app_id"] == @app.id }
      end

      test "should create app_activity" do
        assert_difference("AppActivity.count") do
          post api_v1_app_activities_url, params: {
            app_activity: {
              app_id: @app.id,
              activity_type: "app_usage",
              app_meta: { duration: "5m" }.to_json
            }
          }, as: :json
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        assert_equal true, json_response["success"]
        assert_equal "App activity created successfully", json_response["message"]
        assert_not_nil json_response["data"]["app_activity"]
      end

      test "should not create app_activity with invalid params" do
        assert_no_difference("AppActivity.count") do
          post api_v1_app_activities_url, params: {
            app_activity: {
              app_id: nil,
              activity_type: nil
            }
          }, as: :json
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_equal false, json_response["success"]
        assert_not_nil json_response["errors"]
      end

      test "should require authentication" do
        sign_out @user
        
        get api_v1_app_activities_url, as: :json
        assert_response :unauthorized

        post api_v1_app_activities_url, params: {
          app_activity: {
            app_id: @app.id,
            activity_type: "app_usage"
          }
        }, as: :json
        assert_response :unauthorized
      end
    end
  end
end