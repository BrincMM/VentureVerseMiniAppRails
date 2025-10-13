require "test_helper"

module Api
  module V1
    module Developers
      class ProfilesControllerTest < ActionDispatch::IntegrationTest
        setup do
          @developer = developers(:one)
        end

        test "should reject request without token" do
          get api_v1_developers_profile_url, params: { email: @developer.email }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          get api_v1_developers_profile_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: { email: @developer.email }, as: :json
          assert_response :unauthorized
        end

        test "should get developer profile successfully" do
          get_with_token api_v1_developers_profile_url, params: { email: @developer.email }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Profile retrieved successfully", json_response["message"]
          
          developer_data = json_response["data"]["developer"]
          assert_equal @developer.id, developer_data["id"]
          assert_equal @developer.email, developer_data["email"]
          assert_equal @developer.name, developer_data["name"]
          assert_equal @developer.github, developer_data["github"]
          assert_equal @developer.status, developer_data["status"]
          assert_equal @developer.role, developer_data["role"]
        end

        test "should return not found for non-existent developer" do
          get_with_token api_v1_developers_profile_url, params: { email: "nonexistent@example.com" }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        test "should update developer profile successfully" do
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {
            name: "Updated Developer Name",
            github: "https://github.com/updated_github"
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Profile updated successfully", json_response["message"]
          
          developer_data = json_response["data"]["developer"]
          assert_equal "Updated Developer Name", developer_data["name"]
          assert_equal "https://github.com/updated_github", developer_data["github"]

          # Verify database state
          @developer.reload
          assert_equal "Updated Developer Name", @developer.name
          assert_equal "https://github.com/updated_github", @developer.github
        end

        test "should update only name" do
          original_github = @developer.github
          
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {
            name: "Only Name Updated"
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          developer_data = json_response["data"]["developer"]
          
          assert_equal "Only Name Updated", developer_data["name"]
          assert_equal original_github, developer_data["github"]
        end

        test "should update only github" do
          original_name = @developer.name
          
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {
            github: "https://github.com/new_github_username"
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          developer_data = json_response["data"]["developer"]
          
          assert_equal original_name, developer_data["name"]
          assert_equal "https://github.com/new_github_username", developer_data["github"]
        end

        test "should fail to update with invalid github url" do
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {
            github: "not-a-valid-url"
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to update profile", json_response["message"]
          assert_includes json_response["errors"], "Github must be a valid URL"
        end

        test "should return not found when updating non-existent developer" do
          patch_with_token "/api/v1/developers/99999/profile", params: {
            name: "Updated Name"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        test "should handle empty update params" do
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {}, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          assert_equal true, json_response["success"]
        end

        test "should successfully update profile without changing email" do
          original_email = @developer.email
          
          patch_with_token "/api/v1/developers/#{@developer.id}/profile", params: {
            name: "New Name"
          }, as: :json

          assert_response :success
          @developer.reload
          assert_equal original_email, @developer.email  # Email should not change
          assert_equal "New Name", @developer.name
        end
      end
    end
  end
end

