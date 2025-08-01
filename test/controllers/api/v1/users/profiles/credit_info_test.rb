require "test_helper"

module Api
  module V1
    module Users
      class ProfilesControllerTest < ActionDispatch::IntegrationTest
        setup do
          @user = users(:user_one)
          @tier = tiers(:tier_one)
          @user.update(tier: @tier)
        end

        test "should get credit info" do
          get api_v1_users_profile_credit_info_path(user_id: @user.id)
          assert_response :success
          
          json_response = JSON.parse(@response.body)
          assert_equal true, json_response['success']
          assert_equal 'Credit info retrieved successfully', json_response['message']
          
          user = json_response['data']['user']
          assert_not_nil user
          assert_not_nil user['tier']
          assert_equal @tier.id, user['tier']['id']
          assert_not_nil user['monthly_credit_balance']
          assert_not_nil user['topup_credit_balance']
          assert_not_nil user['remaining_ratio']
        end

        test "should return error for non-existent user" do
          get api_v1_users_profile_credit_info_path(user_id: 999999)
          assert_response :not_found
          
          json_response = JSON.parse(@response.body)
          assert_equal false, json_response['success']
          assert_equal 'User not found', json_response['message']
        end
      end
    end
  end
end