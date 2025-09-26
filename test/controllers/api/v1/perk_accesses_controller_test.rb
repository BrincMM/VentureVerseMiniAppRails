require "test_helper"

class Api::V1::PerkAccessesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @perk = perks(:perk_one)
    @perk_two = perks(:perk_two)
    @existing_access = perk_accesses(:perk_access_one)
  end

  test "should reject request without token" do
    post api_v1_perk_accesses_url, params: { user_id: @user.id, perk_id: @perk.id }, as: :json
    assert_response :unauthorized
  end

  test "should reject request with invalid token" do
    post api_v1_perk_accesses_url,
         params: { user_id: @user.id, perk_id: @perk.id },
         headers: { 'Authorization' => 'Bearer invalid_token' },
         as: :json
    assert_response :unauthorized
  end

  test "should create perk access" do
    assert_difference("PerkAccess.count", 1) do
      post_with_token api_v1_perk_accesses_url,
                      params: { user_id: @user.id, perk_id: @perk_two.id },
                      as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perk access granted successfully", json_response["message"]
    assert_equal @user.id, json_response["data"]["perk_access"]["user_id"]
    assert_equal @perk_two.id, json_response["data"]["perk_access"]["perk_id"]
  end

  test "should not create duplicate perk access" do
    assert_no_difference("PerkAccess.count") do
      post_with_token api_v1_perk_accesses_url,
                      params: { user_id: @existing_access.user_id, perk_id: @existing_access.perk_id },
                      as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "User already has access to this perk"
  end

  test "should handle missing user" do
    post_with_token api_v1_perk_accesses_url,
                    params: { user_id: 0, perk_id: @perk.id },
                    as: :json
    assert_response :not_found
  end

  test "should handle missing perk" do
    post_with_token api_v1_perk_accesses_url,
                    params: { user_id: @user.id, perk_id: 0 },
                    as: :json
    assert_response :not_found
  end

  test "should destroy perk access" do
    assert_difference("PerkAccess.count", -1) do
      delete_with_token api_v1_perk_access_url(@existing_access), as: :json
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perk access revoked successfully", json_response["message"]
  end

  test "should handle missing perk access on destroy" do
    delete_with_token api_v1_perk_access_url(-1), as: :json
    assert_response :not_found
  end
end

