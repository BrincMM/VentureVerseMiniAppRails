require "test_helper"

module Api
  class HealthControllerTest < ActionDispatch::IntegrationTest
    test "should get health status" do
      get api_health_url
      assert_response :success
      
      json_response = JSON.parse(response.body)
      assert_equal "up", json_response["status"]
      assert_equal Rails.env, json_response["environment"]
      assert_not_nil json_response["timestamp"]
    end

    test "should return json content type" do
      get api_health_url
      assert_equal "application/json; charset=utf-8", response.content_type
    end
  end
end 