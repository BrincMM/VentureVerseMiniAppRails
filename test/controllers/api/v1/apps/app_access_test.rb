require "test_helper"

module Api
  module V1
    class AppAccessTest < ActionDispatch::IntegrationTest
      include Rails.application.routes.url_helpers
      setup do
        @user = users(:user_one)
        @app1 = apps(:app_one)
        @app2 = apps(:app_two)
        
        # Clean up any existing accesses
        AppAccess.where(user: @user).destroy_all
      end

      test "should add access to apps" do
        post_with_token add_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [@app1.id, @app2.id]
        }

        assert_response :success
        response_body = JSON.parse(response.body)
        assert_equal "Access granted successfully", response_body["message"]
        assert response_body["success"]

        # Verify access was created
        assert AppAccess.exists?(user: @user, app: @app1)
        assert AppAccess.exists?(user: @user, app: @app2)
        assert_equal 2, AppAccess.where(user: @user).count
      end

      test "should handle duplicate access gracefully" do
        # Create initial access
        AppAccess.create!(user: @user, app: @app1)
        initial_count = AppAccess.count

        post_with_token add_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [@app1.id, @app2.id]
        }

        assert_response :success
        response_body = JSON.parse(response.body)
        assert_equal "Access granted successfully", response_body["message"]

        # Verify no duplicate was created
        assert_equal initial_count + 1, AppAccess.count  # Only @app2 should be added
        assert_equal 1, AppAccess.where(user: @user, app: @app1).count
        assert_equal 1, AppAccess.where(user: @user, app: @app2).count
      end

      test "should handle invalid user_id" do
        post_with_token add_access_api_v1_apps_path, params: {
          user_id: 999999,
          app_ids: [@app1.id]
        }

        assert_response :not_found
        response_body = JSON.parse(response.body)
        assert_equal "User not found", response_body["message"]
      end

      test "should handle invalid app_ids" do
        post_with_token add_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [999999]
        }

        assert_response :not_found
        response_body = JSON.parse(response.body)
        assert_equal "Invalid app IDs", response_body["message"]
      end
    end
  end
end
