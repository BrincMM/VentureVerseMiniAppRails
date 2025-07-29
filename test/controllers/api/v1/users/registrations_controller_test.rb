require "test_helper"

module Api
  module V1
    module Users
      class RegistrationsControllerTest < ActionDispatch::IntegrationTest
        test "should create user with google signup" do
          puts "\nGoogle Signup Endpoint: #{api_v1_users_google_signup_url}"
          
          assert_difference('User.count') do
            post api_v1_users_google_signup_url, params: {
              email: "newuser@example.com",
              google_id: "google123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          puts "\nGoogle Signup Response:"
          puts JSON.pretty_generate(json_response)
          
          assert_equal true, json_response["success"]
          assert_equal "User created successfully", json_response["message"]
          
          user_data = json_response["data"]
          assert_basic_user_data(user_data)
          assert_equal "google123", user_data["google_id"]
          assert_equal 0.0, user_data["monthly_credit_balance"]
          assert_equal 0.0, user_data["top_up_credit_balance"]
        end

        test "should create user with email signup" do
          puts "\nEmail Signup Endpoint: #{api_v1_users_email_signup_url}"
          
          assert_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "newuser@example.com",
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          puts "\nEmail Signup Response:"
          puts JSON.pretty_generate(json_response)
          
          assert_equal true, json_response["success"]
          assert_equal "User created successfully", json_response["message"]
          
          user_data = json_response["data"]
          assert_basic_user_data(user_data)
          assert_nil user_data["google_id"]
          assert_equal 0.0, user_data["monthly_credit_balance"]
          assert_equal 0.0, user_data["top_up_credit_balance"]
        end

        test "should create user with all optional params" do
          puts "\nEmail Signup with Optional Params Endpoint: #{api_v1_users_email_signup_url}"
          
          assert_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "newuser@example.com",
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true,
              country: "US",
              nick_name: "johndoe123",
              linkedIn: "https://linkedin.com/johndoe",
              twitter: "https://twitter.com/johndoe",
              avatar: "https://example.com/avatar.jpg",
              user_roles: ["Founder", "Mentor"]
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          puts "\nEmail Signup with Optional Params Response:"
          puts JSON.pretty_generate(json_response)
          
          user_data = json_response["data"]
          
          # Check all optional fields
          assert_equal "US", user_data["country"]
          assert_equal "johndoe123", user_data["nick_name"]
          assert_equal "https://linkedin.com/johndoe", user_data["linkedIn"]
          assert_equal "https://twitter.com/johndoe", user_data["twitter"]
          assert_equal "https://example.com/avatar.jpg", user_data["avatar"]
          assert_equal 0.0, user_data["monthly_credit_balance"]
          assert_equal 0.0, user_data["top_up_credit_balance"]

          # Check roles were created
          user = User.find(user_data["id"])
          assert user.founder?
          assert user.mentor?
          assert_not user.investor?
        end

        test "should not create user with google signup when missing required fields" do
          assert_no_difference('User.count') do
            post api_v1_users_google_signup_url, params: {
              email: "newuser@example.com",
              google_id: "google123"
              # missing first_name, last_name, age_consent
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_equal false, json_response["success"]
          assert_equal "Failed to create user", json_response["message"]
          assert_includes json_response["errors"], "First name can't be blank"
          assert_includes json_response["errors"], "Last name can't be blank"
          assert_includes json_response["errors"], "Age consent can't be blank"
        end

        test "should not create user with email signup when missing required fields" do
          assert_no_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "newuser@example.com"
              # missing password, first_name, last_name, age_consent
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_equal false, json_response["success"]
          assert_equal "Failed to create user", json_response["message"]
          assert_includes json_response["errors"], "First name can't be blank"
          assert_includes json_response["errors"], "Last name can't be blank"
          assert_includes json_response["errors"], "Age consent can't be blank"
          assert_includes json_response["errors"], "Password can't be blank"
        end

        test "should not create user with invalid email" do
          assert_no_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "invalid-email",
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Email is invalid"
        end

        test "should not create user with duplicate email" do
          existing_user = users(:user_one)

          assert_no_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: existing_user.email,
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Email has already been taken"
        end

        test "should not create user with duplicate nick_name" do
          existing_user = users(:user_one)

          assert_no_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "new@example.com",
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true,
              nick_name: existing_user.nick_name
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Nick name has already been taken"
        end

        test "should not create user with invalid URLs" do
          assert_no_difference('User.count') do
            post api_v1_users_email_signup_url, params: {
              email: "new@example.com",
              password: "password123",
              first_name: "John",
              last_name: "Doe",
              age_consent: true,
              linkedIn: "invalid-url",
              twitter: "invalid-url",
              avatar: "invalid-url"
            }, as: :json
          end

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          assert_includes json_response["errors"], "Linkedin must be a valid URL"
          assert_includes json_response["errors"], "Twitter must be a valid URL"
          assert_includes json_response["errors"], "Avatar must be a valid URL"
        end

        private

        def assert_basic_user_data(user_data)
          assert user_data["id"].present?
          assert_equal "newuser@example.com", user_data["email"]
          assert_equal "John", user_data["first_name"]
          assert_equal "Doe", user_data["last_name"]
          assert_equal true, user_data["age_consent"]
          assert user_data["created_at"].present?
          assert user_data["updated_at"].present?
        end
      end
    end
  end
end 