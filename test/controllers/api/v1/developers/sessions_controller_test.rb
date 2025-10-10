require "test_helper"

module Api
  module V1
    module Developers
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        setup do
          @developer = developers(:one)
        end

        test "should reject request without token" do
          post api_v1_developers_verify_password_url, params: {
            email: @developer.email,
            password: "password123"
          }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          post api_v1_developers_verify_password_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                email: @developer.email,
                password: "password123"
              }, as: :json
          assert_response :unauthorized
        end

        test "should verify password successfully" do
          post_with_token api_v1_developers_verify_password_url, params: {
            email: @developer.email,
            password: "password123"
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Password verified successfully", json_response["message"]
          
          developer_data = json_response["data"]["developer"]
          assert_equal @developer.id, developer_data["id"]
          assert_equal @developer.email, developer_data["email"]
          assert_equal @developer.name, developer_data["name"]

          # Verify sign_in_count increased
          @developer.reload
          assert_equal 6, @developer.sign_in_count  # Initial was 5 in fixture
        end

        test "should fail with invalid password" do
          post_with_token api_v1_developers_verify_password_url, params: {
            email: @developer.email,
            password: "wrong_password"
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should fail with non-existent email" do
          post_with_token api_v1_developers_verify_password_url, params: {
            email: "nonexistent@example.com",
            password: "password123"
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should fail with missing parameters" do
          post_with_token api_v1_developers_verify_password_url, params: {}, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should update password successfully" do
          patch_with_token api_v1_developers_update_password_url, params: {
            email: @developer.email,
            password: "newpassword123"
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Password updated successfully", json_response["message"]
          
          developer_data = json_response["data"]["developer"]
          assert_equal @developer.id, developer_data["id"]
          assert_equal @developer.email, developer_data["email"]

          # Verify new password works
          post_with_token api_v1_developers_verify_password_url, params: {
            email: @developer.email,
            password: "newpassword123"
          }, as: :json
          assert_response :ok
        end

        test "should fail to update password with non-existent email" do
          patch_with_token api_v1_developers_update_password_url, params: {
            email: "nonexistent@example.com",
            password: "newpassword123"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        test "should fail to update password with invalid password" do
          patch_with_token api_v1_developers_update_password_url, params: {
            email: @developer.email,
            password: "123"  # Too short
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_includes json_response["errors"], "Password is too short (minimum is 6 characters)"
        end

        test "should fail to update password with missing parameters" do
          patch_with_token api_v1_developers_update_password_url, params: {}, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end
      end
    end
  end
end


