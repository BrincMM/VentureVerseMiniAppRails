require "test_helper"

module Api
  module V1
    module Users
      class SessionsControllerTest < ActionDispatch::IntegrationTest
        test "should verify password successfully" do
          user = users(:user_one)
          
          post api_v1_users_verify_password_url, params: {
            email: user.email,
            password: "password123" # Assuming this is the password in fixtures
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "User logged in", json_response["message"]
          
          user_data = json_response["data"]["user"]
          assert_equal user.id, user_data["id"]
          assert_equal user.email, user_data["email"]
          assert_equal user.first_name, user_data["first_name"]
          assert_equal user.last_name, user_data["last_name"]
          assert user_data["user_roles"].is_a?(Array)
        end

        test "should fail with invalid password" do
          user = users(:user_one)
          
          post api_v1_users_verify_password_url, params: {
            email: user.email,
            password: "wrong_password"
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should fail with non-existent email" do
          post api_v1_users_verify_password_url, params: {
            email: "nonexistent@example.com",
            password: "password123"
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should fail with missing parameters" do
          post api_v1_users_verify_password_url, params: {}, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid email or password", json_response["message"]
        end

        test "should update password successfully" do
          user = users(:user_one)
          
          patch api_v1_users_update_password_url, params: {
            email: user.email,
            password: "newpassword123"
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Password updated successfully", json_response["message"]
          
          user_data = json_response["data"]["user"]
          assert_equal user.id, user_data["id"]
          assert_equal user.email, user_data["email"]

          # Verify new password works
          post api_v1_users_verify_password_url, params: {
            email: user.email,
            password: "newpassword123"
          }, as: :json
          assert_response :ok
        end

        test "should fail to update password with non-existent email" do
          patch api_v1_users_update_password_url, params: {
            email: "nonexistent@example.com",
            password: "newpassword123"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "User not found", json_response["message"]
        end

        test "should fail to update password with missing parameters" do
          patch api_v1_users_update_password_url, params: {}, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "User not found", json_response["message"]
        end
      end
    end
  end
end 