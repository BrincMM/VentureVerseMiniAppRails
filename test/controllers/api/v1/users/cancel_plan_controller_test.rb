require "test_helper"

module Api
  module V1
    module Users
      class CancelPlanControllerTest < ActionDispatch::IntegrationTest
        setup do
          @user = users(:user_one)
          @stripe_info = stripe_infos(:stripe_one)
        end

        test "should reject request without token" do
          post api_v1_users_cancel_plan_path, params: {
            user_id: @user.id
          }
          assert_response :unauthorized
        end

        test "should reject request with invalid token" do
          post api_v1_users_cancel_plan_path,
              headers: { 'Authorization' => 'Bearer invalid_token' },
              params: {
                user_id: @user.id
              }
          assert_response :unauthorized
        end

        test "should cancel plan successfully" do
          post_with_token api_v1_users_cancel_plan_path, params: {
            user_id: @user.id
          }

          assert_response :success
          response_body = JSON.parse(response.body)
          assert_equal true, response_body['success']
          assert_equal 'Plan cancelled successfully', response_body['message']
          assert_equal 'canceled', @user.stripe_info.reload.subscription_status
        end

        test "should return error when user not found" do
          post_with_token api_v1_users_cancel_plan_path, params: {
            user_id: 999999
          }

          assert_response :not_found
          response_body = JSON.parse(response.body)
          assert_equal false, response_body['success']
          assert_equal 'User not found', response_body['message']
        end

        test "should return error when no active subscription" do
          @user.stripe_info.update!(subscription_status: 'canceled')
          
          post_with_token api_v1_users_cancel_plan_path, params: {
            user_id: @user.id
          }

          assert_response :unprocessable_entity
          response_body = JSON.parse(response.body)
          assert_equal false, response_body['success']
          assert_equal 'No active subscription found', response_body['message']
        end
      end
    end
  end
end