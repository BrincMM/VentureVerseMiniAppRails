require "test_helper"

module Api
  module V1
    module Users
      class ForgetPasswordsControllerTest < ActionDispatch::IntegrationTest
        test "should reject request without token" do
          post api_v1_users_forget_password_url, params: {
            email: "test@example.com"
          }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          post api_v1_users_forget_password_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                email: "test@example.com"
              }, as: :json
          assert_response :unauthorized
        end
        test "should create forget password code successfully" do
          user = users(:user_one)
          
          assert_difference('ForgetPassword.count') do
            post_with_token api_v1_users_forget_password_url, params: {
              email: user.email
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Verification code sent successfully", json_response["message"]
          assert_equal user.email, json_response["data"]["email"]
          
          # Verify the code is 6 digits
          forget_password = ForgetPassword.last
          assert_equal 6, forget_password.code.to_s.length
          assert_equal user.email, forget_password.email
        end

        test "should fail with non-existent email" do
          post_with_token api_v1_users_forget_password_url, params: {
            email: "nonexistent@example.com"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "User not found", json_response["message"]
        end

        test "should fail with missing email parameter" do
          post_with_token api_v1_users_forget_password_url, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to create verification code", json_response["message"]
        end

        test "should verify code successfully" do
          user = users(:user_one)
          forget_password = forget_passwords(:forget_password_one)
          
          post_with_token api_v1_users_verify_forget_password_url, params: {
            email: forget_password.email,
            code: forget_password.code
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Code verified successfully", json_response["message"]
          assert_equal forget_password.email, json_response["data"]["email"]
        end

        test "should fail with invalid code" do
          user = users(:user_one)
          forget_password = forget_passwords(:forget_password_one)
          
          post_with_token api_v1_users_verify_forget_password_url, params: {
            email: forget_password.email,
            code: "999999" # Wrong code
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid or expired code", json_response["message"]
        end

        test "should fail with expired code" do
          user = users(:user_one)
          forget_password = forget_passwords(:forget_password_one)
          
          # Update created_at to be more than 1 hour ago
          forget_password.update_column(:created_at, 2.hours.ago)
          
          post_with_token api_v1_users_verify_forget_password_url, params: {
            email: forget_password.email,
            code: forget_password.code
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid or expired code", json_response["message"]
        end

        test "should fail with missing parameters for verify" do
          post_with_token api_v1_users_verify_forget_password_url, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to verify code", json_response["message"]
          assert_includes json_response["errors"], "Email and code are required"
        end
      end
    end
  end
end
