require "test_helper"

class Api::V1::Users::PerksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_one)
    @perk_one = perks(:perk_one)
    @perk_two = perks(:perk_two)

    # Ensure user has known perks
    @user.perk_accesses.destroy_all
    @user.perk_accesses.create!(perk: @perk_one)
    @user.perk_accesses.create!(perk: @perk_two)

    @perk_one.tag_list.add("remote", "discount")
    @perk_one.save!
    @perk_two.tag_list.add("wellness")
    @perk_two.save!
  end

  test "should reject request without token" do
    get api_v1_user_perks_url(@user), as: :json
    assert_response :unauthorized
  end

  test "should reject request with invalid token" do
    get api_v1_user_perks_url(@user),
        headers: { 'Authorization' => 'Bearer invalid_token' },
        as: :json
    assert_response :unauthorized
  end

  test "should list user perks" do
    get_with_token api_v1_user_perks_url(@user), as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "User perks retrieved successfully", json_response["message"]
    assert_equal 2, json_response["data"]["perks"].length
    assert_equal 2, json_response["data"]["total_count"]

    tags = json_response["data"]["perks"].find { |perk| perk["id"] == @perk_one.id }["tags"]
    assert_equal ["discount", "remote"].sort, tags.sort
  end

  test "should filter user perks by category" do
    get_with_token api_v1_user_perks_url(@user), params: { category: "Technology" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    assert_equal "Technology", json_response["data"]["perks"].first["category"]
  end

  test "should filter user perks by tags" do
    get_with_token api_v1_user_perks_url(@user), params: { tags: "remote" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    assert_equal @perk_one.id, json_response["data"]["perks"].first["id"]
  end

  test "should paginate user perks" do
    get_with_token api_v1_user_perks_url(@user), params: { per_page: 1, page: 1 }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    assert_equal 2, json_response["data"]["total_count"]
    assert_equal true, json_response["data"]["has_next"]

    get_with_token api_v1_user_perks_url(@user), params: { per_page: 1, page: 2 }, as: :json
    assert_response :success
  end

  test "should handle invalid per_page" do
    get_with_token api_v1_user_perks_url(@user), params: { per_page: 0 }, as: :json
    assert_response :unprocessable_entity
  end

  test "should handle missing user" do
    get_with_token api_v1_user_perks_url(-1), as: :json
    assert_response :not_found
  end
end



