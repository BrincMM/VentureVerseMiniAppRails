require "test_helper"

class Api::V1::TiersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tier_one = tiers(:tier_one)
    @tier_two = tiers(:tier_two)
  end

  test "should reject request without token" do
    get api_v1_tiers_url, as: :json
    assert_response :unauthorized
  end

  test "should reject request with invalid token" do
    get api_v1_tiers_url,
        headers: { 'Authorization' => 'Bearer invalid_token' },
        as: :json
    assert_response :unauthorized
  end

  test "should get list of active tiers" do
    get_with_token api_v1_tiers_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Tiers retrieved successfully", json_response["message"]
    
    # Only active tiers should be returned
    active_tiers = [@tier_one, @tier_two].select(&:active).sort_by(&:monthly_tier_price)
    assert_equal active_tiers.count, json_response["data"]["tiers"].length

    # Verify tiers are ordered by monthly price (low to high)
    json_response["data"]["tiers"].each_with_index do |tier_data, index|
      tier = active_tiers[index]
      assert_equal tier.id, tier_data["id"], "Tiers not ordered by monthly price"
      assert_equal tier.name, tier_data["name"]
      assert_equal tier.stripe_price_id, tier_data["stripe_price_id"]
      assert_equal tier.active, tier_data["active"]
      assert_equal tier.monthly_tier_price.to_s, tier_data["monthly_tier_price"].to_s
    end
  end
end