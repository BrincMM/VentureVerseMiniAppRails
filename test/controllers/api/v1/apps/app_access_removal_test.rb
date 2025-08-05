require "test_helper"

module Api
  module V1
    class AppAccessRemovalTest < ActionDispatch::IntegrationTest
      include Rails.application.routes.url_helpers
      setup do
        @user = users(:user_one)
        @app1 = apps(:app_one)
        @app2 = apps(:app_two)
        
        # Clean up any existing accesses and create new ones
        AppAccess.where(user: @user).destroy_all
        AppAccess.create!(user: @user, app: @app1)
        AppAccess.create!(user: @user, app: @app2)
      end

      test "should remove access to apps" do
        delete_with_token remove_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [@app1.id, @app2.id]
        }

        assert_response :success
        response_body = JSON.parse(response.body)
        puts response_body
        assert_equal "Access removed successfully", response_body["message"]

        # Verify access was removed
        refute AppAccess.exists?(user: @user, app: @app1)
        refute AppAccess.exists?(user: @user, app: @app2)
      end

      test "should handle non-existent access" do
        delete_with_token remove_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [999999]
        }

        assert_response :not_found
        response_body = JSON.parse(response.body)
        assert_equal "No access found", response_body["message"]
      end

      test "should handle invalid user_id" do
        delete_with_token remove_access_api_v1_apps_path, params: {
          user_id: 999999,
          app_ids: [@app1.id]
        }

        assert_response :not_found
        response_body = JSON.parse(response.body)
        assert_equal "User not found", response_body["message"]
      end

      test "should handle partial access removal" do
        delete_with_token remove_access_api_v1_apps_path, as: :json, params: {
          user_id: @user.id,
          app_ids: [@app1.id, 999999]
        }

        assert_response :success
        response_body = JSON.parse(response.body)
        assert_equal "Access removed successfully", response_body["message"]

        # Verify correct access was removed
        refute AppAccess.exists?(user: @user, app: @app1)
        assert AppAccess.exists?(user: @user, app: @app2)
      end
    end
  end
end
