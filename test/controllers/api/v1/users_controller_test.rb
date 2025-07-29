require "test_helper"

module Api
  module V1
    class UsersControllerTest < ActionDispatch::IntegrationTest
      test "should create user with valid params" do
        assert_difference('User.count') do
          post api_v1_users_url, params: {
            email: "newuser@example.com",
            google_id: "google123",
            first_name: "John",
            last_name: "Doe",
            age_consent: true
          }, as: :json
        end

        assert_response :created
        json_response = JSON.parse(response.body)
        
        assert_equal true, json_response["success"]
        assert_equal "User created through google", json_response["message"]
        assert_equal "newuser@example.com", json_response["data"]["email"]
        assert_equal "John", json_response["data"]["first_name"]
        assert_equal "Doe", json_response["data"]["last_name"]
        assert_equal "google123", json_response["data"]["google_id"]
      end

      test "should create user with optional params" do
        assert_difference('User.count') do
          post api_v1_users_url, params: {
            email: "newuser@example.com",
            google_id: "google123",
            first_name: "John",
            last_name: "Doe",
            age_consent: true,
            country: "US",
            nick_name: "johndoe123",
            linkedIn: "linkedin.com/johndoe",
            twitter: "twitter.com/johndoe",
            user_roles: ["Founder", "Mentor"]
          }, as: :json
        end

        assert_response :created
        user = User.last
        assert_equal "US", user.country
        assert_equal "johndoe123", user.nick_name
        assert user.founder?
        assert user.mentor?
      end

      test "should not create user with invalid params" do
        assert_no_difference('User.count') do
          post api_v1_users_url, params: {
            email: "invalid-email",
            google_id: "google123",
            first_name: "John",
            last_name: "Doe",
            age_consent: true
          }, as: :json
        end

        assert_response :unprocessable_entity
        json_response = JSON.parse(response.body)
        assert_equal false, json_response["success"]
        assert_equal "Failed to create user", json_response["message"]
        assert_includes json_response["errors"], "Email is invalid"
      end
    end
  end
end 