require "test_helper"

module Api
  module V1
    module Users
      class ChangePlanControllerTest < ActionDispatch::IntegrationTest
        setup do
          @user = users(:user_one)
          @tier = tiers(:tier_two)  # Using Pro tier for upgrade test
          @stripe_info = stripe_infos(:stripe_one)
        end

        test "should change plan successfully" do
          post api_v1_users_change_plan_path, params: {
            user_id: @user.id,
            tier_id: @tier.id,
            subscription_id: "new_sub_id",
            next_subscription_time: 1.month.from_now,
            stripe_customer_id: "new_cus_id"
          }

          assert_response :success
          response_body = JSON.parse(response.body)
          assert_equal true, response_body["success"]
          assert_equal "Plan changed successfully", response_body["message"]
          assert_equal @tier.id, response_body["data"]["user"]["tier_id"]
          assert_equal "new_sub_id", response_body["data"]["user"]["stripe_info"]["subscription_id"]
        end

        test "should return error when user not found" do
          post api_v1_users_change_plan_path, params: {
            user_id: 999999,
            tier_id: @tier.id,
            subscription_id: "new_sub_id",
            next_subscription_time: 1.month.from_now
          }

          assert_response :not_found
          response_body = JSON.parse(response.body)
          assert_equal false, response_body["success"]
          assert_equal "User not found", response_body["message"]
        end

        test "should return error when tier not found" do
          post api_v1_users_change_plan_path, params: {
            user_id: @user.id,
            tier_id: 999999,
            subscription_id: "new_sub_id",
            next_subscription_time: 1.month.from_now
          }

          assert_response :not_found
          response_body = JSON.parse(response.body)
          assert_equal false, response_body["success"]
          assert_equal "Tier not found", response_body["message"]
        end

        test "should return error when required params missing" do
          post api_v1_users_change_plan_path, params: {
            user_id: @user.id,
            tier_id: @tier.id
          }

          assert_response :unprocessable_entity
          response_body = JSON.parse(response.body)
          assert_equal false, response_body["success"]
          assert_equal "Failed to change plan", response_body["message"]
          assert_includes response_body["errors"], "Subscription can't be blank"
        end
      end
    end
  end
end