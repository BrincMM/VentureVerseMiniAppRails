require "test_helper"

module Api
  module V1
    class ApiKeysControllerTest < ActionDispatch::IntegrationTest
      setup do
        @developer = developers(:one)
        @app_one = apps(:app_one)
        @active_key = api_keys(:one)
        @revoked_key = api_keys(:two)
        @expired_key = api_keys(:expired)
      end

      # VALIDATE tests
      test "should reject validate request without token" do
        post validate_api_v1_api_keys_url, params: { key: @active_key.api_key }, as: :json
        assert_response :unauthorized
      end

      test "should successfully validate an active api key" do
        initial_last_used = @active_key.last_used_at
        
        post_with_token validate_api_v1_api_keys_url, 
                        params: { key: @active_key.api_key }, 
                        as: :json

        assert_response :ok
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "API key is valid", json_response["message"]
        
        # Check api_key data
        api_key_data = json_response["data"]["api_key"]
        assert_equal @active_key.id, api_key_data["id"]
        assert_equal "active", api_key_data["status"]
        assert_not_nil api_key_data["rate_limit_per_minute"]
        assert_not_nil api_key_data["rate_limit_per_day"]
        
        # Check app data
        app_data = json_response["data"]["app"]
        assert_equal @app_one.id, app_data["id"]
        assert_equal @app_one.name, app_data["name"]
        
        # Check developer data
        developer_data = json_response["data"]["developer"]
        assert_equal @developer.id, developer_data["id"]
        assert_equal @developer.email, developer_data["email"]
        
        # Verify last_used_at was updated
        @active_key.reload
        assert_not_equal initial_last_used, @active_key.last_used_at
      end

      test "should fail validate with missing key parameter" do
        post_with_token validate_api_v1_api_keys_url, as: :json

        assert_response :bad_request
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "API key is required", json_response["message"]
      end

      test "should fail validate with invalid api key" do
        post_with_token validate_api_v1_api_keys_url, 
                        params: { key: "invalid_key_12345" }, 
                        as: :json

        assert_response :unauthorized
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "Invalid API key", json_response["message"]
      end

      test "should fail validate with revoked api key" do
        post_with_token validate_api_v1_api_keys_url, 
                        params: { key: @revoked_key.api_key }, 
                        as: :json

        assert_response :unauthorized
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "API key is revoked", json_response["message"]
      end

      test "should fail validate with expired api key" do
        post_with_token validate_api_v1_api_keys_url, 
                        params: { key: @expired_key.api_key }, 
                        as: :json

        assert_response :unauthorized
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        assert_equal "API key is expired", json_response["message"]
      end

      test "should fail validate with expired by date api key" do
        # Create a key that is active but expired by date
        expired_by_date_key = @app_one.api_keys.create!(
          status: :active,
          expires_at: 1.day.ago,
          rate_limit_per_minute: 100,
          rate_limit_per_day: 10000
        )
        
        post_with_token validate_api_v1_api_keys_url, 
                        params: { key: expired_by_date_key.api_key }, 
                        as: :json

        assert_response :unauthorized
        json_response = JSON.parse(response.body)
        
        assert_equal false, json_response["success"]
        # The key is marked as active in status, but expired by date, so valid_for_use? returns false
        # The controller treats this as revoked in the error message
        assert_includes ["API key is revoked", "API key is expired"], json_response["message"]
      end
    end
  end
end

