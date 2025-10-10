require "test_helper"

module Api
  module V1
    module Developers
      class ApiKeysControllerTest < ActionDispatch::IntegrationTest
        setup do
          @developer = developers(:one)
          @app_one = apps(:app_one)
          @app_two = apps(:app_two)
          @active_key = api_keys(:one)
          @revoked_key = api_keys(:two)
          @expired_key = api_keys(:expired)
        end

        # ROTATE tests
        test "should reject rotate request without token" do
          post rotate_api_v1_developers_app_api_keys_url(@app_one), as: :json
          assert_response :unauthorized
        end

        test "should successfully rotate api key" do
          # Get the current active key count
          initial_key_count = @app_one.api_keys.count
          initial_active_key = @app_one.api_keys.find_by(status: :active)
          
          post_with_token rotate_api_v1_developers_app_api_keys_url(@app_one), as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "API key rotated successfully", json_response["message"]
          
          api_key_data = json_response["data"]["api_key"]
          assert_not_nil api_key_data["id"]
          assert_not_nil api_key_data["api_key"]
          assert_equal @app_one.id, api_key_data["app_id"]
          assert_equal "active", api_key_data["status"]
          
          # Verify the old key is expired
          initial_active_key.reload
          assert_equal "expired", initial_active_key.status
          
          # Verify we have one more key now
          assert_equal initial_key_count + 1, @app_one.api_keys.count
          
          # Verify only one active key exists
          assert_equal 1, @app_one.api_keys.where(status: :active).count
        end

        test "should fail rotate with non-existent app" do
          post_with_token rotate_api_v1_developers_app_api_keys_url(99999), as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "App not found", json_response["message"]
        end

        test "should create new api key when no active key exists" do
          # Expire all keys for app_two
          @app_two.api_keys.update_all(status: :expired)
          initial_key_count = @app_two.api_keys.count
          
          post_with_token rotate_api_v1_developers_app_api_keys_url(@app_two), as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "API key rotated successfully", json_response["message"]
          
          api_key_data = json_response["data"]["api_key"]
          assert_not_nil api_key_data["id"]
          assert_not_nil api_key_data["api_key"]
          assert_equal @app_two.id, api_key_data["app_id"]
          assert_equal "active", api_key_data["status"]
          
          # Verify default rate limits are used
          assert_equal 100, api_key_data["rate_limit_per_minute"]
          assert_equal 10000, api_key_data["rate_limit_per_day"]
          
          # Verify we have one more key now
          assert_equal initial_key_count + 1, @app_two.api_keys.count
        end

        test "rotated key should inherit rate limits from previous key" do
          original_key = @app_one.api_keys.find_by(status: :active)
          original_rpm = original_key.rate_limit_per_minute
          original_rpd = original_key.rate_limit_per_day
          
          post_with_token rotate_api_v1_developers_app_api_keys_url(@app_one), as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          api_key_data = json_response["data"]["api_key"]
          assert_equal original_rpm, api_key_data["rate_limit_per_minute"]
          assert_equal original_rpd, api_key_data["rate_limit_per_day"]
        end

        test "should rotate api key with custom rate limits" do
          initial_key_count = @app_one.api_keys.count
          initial_active_key = @app_one.api_keys.find_by(status: :active)
          
          post_with_token rotate_api_v1_developers_app_api_keys_url(@app_one), 
                          params: {
                            rate_limit_per_minute: 200,
                            rate_limit_per_day: 20000
                          }, 
                          as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "API key rotated successfully", json_response["message"]
          
          api_key_data = json_response["data"]["api_key"]
          assert_equal 200, api_key_data["rate_limit_per_minute"]
          assert_equal 20000, api_key_data["rate_limit_per_day"]
          assert_equal "active", api_key_data["status"]
          
          # Verify the old key is expired
          initial_active_key.reload
          assert_equal "expired", initial_active_key.status
          
          # Verify we have one more key now
          assert_equal initial_key_count + 1, @app_one.api_keys.count
        end

        test "should create new api key with custom rate limits when no active key exists" do
          # Expire all keys for app_two
          @app_two.api_keys.update_all(status: :expired)
          
          post_with_token rotate_api_v1_developers_app_api_keys_url(@app_two), 
                          params: {
                            rate_limit_per_minute: 500,
                            rate_limit_per_day: 50000
                          }, 
                          as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          
          api_key_data = json_response["data"]["api_key"]
          assert_equal 500, api_key_data["rate_limit_per_minute"]
          assert_equal 50000, api_key_data["rate_limit_per_day"]
          assert_equal "active", api_key_data["status"]
        end
      end
    end
  end
end

