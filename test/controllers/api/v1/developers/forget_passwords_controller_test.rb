require "test_helper"

module Api
  module V1
    module Developers
      class ForgetPasswordsControllerTest < ActionDispatch::IntegrationTest
        setup do
          @developer = developers(:one)
        end

        test "should reject request without token" do
          post api_v1_developers_forget_password_url, params: {
            email: @developer.email
          }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          post api_v1_developers_forget_password_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                email: @developer.email
              }, as: :json
          assert_response :unauthorized
        end

        test "should create forget password code successfully" do
          assert_difference('ForgetPassword.count') do
            post_with_token api_v1_developers_forget_password_url, params: {
              email: @developer.email
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Verification code sent successfully", json_response["message"]
          assert_equal @developer.email, json_response["data"]["email"]

          # Verify the code was created
          forget_password = ForgetPassword.where(email: @developer.email).last
          assert_not_nil forget_password
          assert forget_password.code.to_s.length == 6
        end

        test "should fail with non-existent email" do
          assert_no_difference('ForgetPassword.count') do
            post_with_token api_v1_developers_forget_password_url, params: {
              email: "nonexistent@example.com"
            }, as: :json
          end

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        test "should fail with missing email" do
          assert_no_difference('ForgetPassword.count') do
            post_with_token api_v1_developers_forget_password_url, params: {}, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to create verification code", json_response["message"]
          assert_includes json_response["errors"], "Email is required"
        end

        test "should verify forget password code successfully" do
          # First create a verification code
          code = rand(100000..999999)
          ForgetPassword.create!(email: @developer.email, code: code)

          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email,
            code: code.to_s
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Code verified successfully", json_response["message"]
          assert_equal @developer.email, json_response["data"]["email"]
        end

        test "should fail verification with invalid code" do
          # Create a verification code
          code = rand(100000..999999)
          ForgetPassword.create!(email: @developer.email, code: code)

          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email,
            code: "000000"  # Wrong code
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid or expired code", json_response["message"]
        end

        test "should fail verification with expired code" do
          # Create an old verification code (more than 1 hour ago)
          code = rand(100000..999999)
          forget_password = ForgetPassword.create!(email: @developer.email, code: code)
          forget_password.update_column(:created_at, 2.hours.ago)

          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email,
            code: code.to_s
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid or expired code", json_response["message"]
        end

        test "should fail verification with missing parameters" do
          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email
            # Missing code
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to verify code", json_response["message"]
          assert_includes json_response["errors"], "Email and code are required"
        end

        test "should fail verification with non-existent email" do
          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: "nonexistent@example.com",
            code: "123456"
          }, as: :json

          assert_response :unauthorized
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Invalid or expired code", json_response["message"]
        end

        test "should use most recent code for verification" do
          # Create two codes for the same email
          old_code = rand(100000..999999)
          new_code = rand(100000..999999)
          
          ForgetPassword.create!(email: @developer.email, code: old_code, created_at: 30.minutes.ago)
          ForgetPassword.create!(email: @developer.email, code: new_code, created_at: Time.current)

          # Old code should not work
          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email,
            code: old_code.to_s
          }, as: :json
          assert_response :unauthorized

          # New code should work
          post_with_token api_v1_developers_verify_forget_password_url, params: {
            email: @developer.email,
            code: new_code.to_s
          }, as: :json
          assert_response :ok
        end
      end
    end
  end
end


