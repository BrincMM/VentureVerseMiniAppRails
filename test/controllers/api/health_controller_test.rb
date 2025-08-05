require "test_helper"

module Api
  class HealthControllerTest < ActionDispatch::IntegrationTest
    def setup
      @valid_token = Rails.application.credentials.api_keys.first
    end
    test "should reject request without token" do
      get api_health_url
      assert_response :unauthorized
    end

    test "should reject request with invalid token" do
      get api_health_url, headers: { 'Authorization' => 'Bearer invalid_token' }
      assert_response :unauthorized
    end

    test "should accept request with valid token" do
      get api_health_url, headers: { 'Authorization' => "Bearer #{@valid_token}" }
      assert_response :success
      
      json_response = JSON.parse(response.body)
      assert_equal "up", json_response["status"]
      assert_equal Rails.env, json_response["environment"]
      assert_not_nil json_response["timestamp"]
    end

    test "should return json content type with valid token" do
      get api_health_url, headers: { 'Authorization' => "Bearer #{@valid_token}" }
      assert_equal "application/json; charset=utf-8", response.content_type
    end
  end
end 