require "test_helper"

module Api
  module V1
    module Developers
      class RegistrationsControllerTest < ActionDispatch::IntegrationTest
        test "should reject request without token" do
          post api_v1_developers_register_url, params: {
            email: "newdev@example.com",
            password: "password123",
            name: "New Developer"
          }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          post api_v1_developers_register_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                email: "newdev@example.com",
                password: "password123",
                name: "New Developer"
              }, as: :json
          assert_response :unauthorized
        end

        test "should create developer successfully" do
          assert_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "newdev@example.com",
              password: "password123",
              name: "New Developer",
              github: "newdev"
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Developer created successfully", json_response["message"]
          
          developer_data = json_response["data"]["developer"]
          assert developer_data["id"].present?
          assert_equal "newdev@example.com", developer_data["email"]
          assert_equal "New Developer", developer_data["name"]
          assert_equal "newdev", developer_data["github"]
          assert_equal "pending", developer_data["status"]
          assert_equal "developer", developer_data["role"]
        end

        test "should create developer without github" do
          assert_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "newdev2@example.com",
              password: "password123",
              name: "Developer Two"
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          developer_data = json_response["data"]["developer"]
          assert_nil developer_data["github"]
        end

        test "should not create developer with missing email" do
          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              password: "password123",
              name: "Developer"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_equal false, json_response["success"]
          assert_includes json_response["errors"], "Email can't be blank"
        end

        test "should not create developer with missing password" do
          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "newdev@example.com",
              name: "Developer"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Password can't be blank"
        end

        test "should not create developer with invalid email" do
          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "invalid-email",
              password: "password123",
              name: "Developer"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Email is invalid"
        end

        test "should not create developer with duplicate email" do
          existing_developer = developers(:one)

          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: existing_developer.email,
              password: "password123",
              name: "Developer"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Email has already been taken"
        end

        test "should not create developer with duplicate github" do
          existing_developer = developers(:one)

          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "newdev@example.com",
              password: "password123",
              name: "Developer",
              github: existing_developer.github
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Github has already been taken"
        end

        test "should not create developer with short password" do
          assert_no_difference('Developer.count') do
            post_with_token api_v1_developers_register_url, params: {
              email: "newdev@example.com",
              password: "12345",
              name: "Developer"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Password is too short (minimum is 6 characters)"
        end
      end
    end
  end
end


