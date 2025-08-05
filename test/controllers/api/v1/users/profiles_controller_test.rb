require "test_helper"

module Api
  module V1
    module Users
      class ProfilesControllerTest < ActionDispatch::IntegrationTest
        setup do
          @user = users(:user_one)
        end

        test "should reject request without token" do
          patch api_v1_users_profile_url, params: {
            first_name: "Updated Name"
          }, as: :json
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          patch api_v1_users_profile_url,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                first_name: "Updated Name"
              }, as: :json
          assert_response :unauthorized
        end

        test "should update user profile successfully" do
          patch_with_token api_v1_users_profile_url, params: {
            first_name: "Updated Name",
            country: "Updated Country",
            nick_name: "updated_nick",
            linkedIn: "https://linkedin.com/in/updated",
            twitter: "https://twitter.com/updated",
            avatar: "https://example.com/updated.jpg"
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Profile updated successfully", json_response["message"]
          
          user_data = json_response["data"]["user"]
          assert_equal "Updated Name", user_data["first_name"]
          assert_equal "Updated Country", user_data["country"]
          assert_equal "updated_nick", user_data["nick_name"]
          assert_equal "https://linkedin.com/in/updated", user_data["linkedIn"]
          assert_equal "https://twitter.com/updated", user_data["twitter"]
          assert_equal "https://example.com/updated.jpg", user_data["avatar"]
        end

        test "should update user roles successfully" do
          patch_with_token api_v1_users_profile_url, params: {
            roles: ["mentor", "investor"]
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal ["mentor", "investor"].sort, json_response["data"]["user"]["user_roles"].sort
          
          # Verify database state
          @user.reload
          assert_equal ["mentor", "investor"].sort, @user.user_roles.pluck(:role).sort
          assert_not @user.founder?
        end

        test "should handle invalid profile updates" do
          patch_with_token api_v1_users_profile_url, params: {
            first_name: "",  # first_name cannot be blank
            nick_name: "janesmith"  # nick_name already taken by user_two
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Failed to update profile", json_response["message"]
          assert_includes json_response["errors"], "First name can't be blank"
          assert_includes json_response["errors"], "Nick name has already been taken"
        end

        test "should handle invalid roles" do
          patch_with_token api_v1_users_profile_url, params: {
            roles: ["invalid_role"]
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          
          # Invalid role should be ignored
          assert_equal [], json_response["data"]["user"]["user_roles"]
        end

        test "should handle partial updates" do
          original_last_name = @user.last_name
          
          patch_with_token api_v1_users_profile_url, params: {
            first_name: "Partial Update"
          }, as: :json

          assert_response :success
          json_response = JSON.parse(response.body)
          user_data = json_response["data"]["user"]
          
          assert_equal "Partial Update", user_data["first_name"]
          assert_equal original_last_name, user_data["last_name"]
        end

        test "should get user profile" do
          get_with_token api_v1_users_profile_path, params: { email: @user.email }
          assert_response :success
          
          json_response = JSON.parse(response.body)
          assert_equal true, json_response['success']
          assert_equal 'Profile retrieved successfully', json_response['message']
          
          user_data = json_response['data']['user']
          assert_equal @user.id, user_data['id']
          assert_equal @user.email, user_data['email']
          assert_equal @user.first_name, user_data['first_name']
          assert_equal @user.last_name, user_data['last_name']
        end

        test "should return not found for non-existent user" do
          get_with_token api_v1_users_profile_path, params: { email: 'nonexistent@example.com' }
          assert_response :not_found
          
          json_response = JSON.parse(response.body)
          assert_equal false, json_response['success']
          assert_equal 'User not found', json_response['message']
        end
      end
    end
  end
end
