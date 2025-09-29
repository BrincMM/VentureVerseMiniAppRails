require "test_helper"

class Api::V1::SectorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sector = sectors(:sector_one)
  end

  test "should reject request without token" do
    get api_v1_sectors_url, as: :json
    assert_response :unauthorized
  end

  test "should list sectors" do
    get_with_token api_v1_sectors_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Sectors retrieved successfully", json_response["message"]
    assert_equal 2, json_response["data"]["sectors"].length
  end

  test "should filter sectors by search" do
    get_with_token api_v1_sectors_url, params: { search: "health" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["sectors"].length
    assert_equal "Healthcare", json_response["data"]["sectors"].first["name"]
  end

  test "should handle invalid per_page" do
    get_with_token api_v1_sectors_url, params: { per_page: 0 }, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "Per page must be between 1 and 100"
  end

  test "should create sector" do
    assert_difference("Sector.count", 1) do
      post_with_token api_v1_sectors_url,
                      params: { sector: { name: "Fintech" } },
                      as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Sector created successfully", json_response["message"]
    assert_equal "Fintech", json_response["data"]["sector"]["name"]
  end

  test "should not create sector with invalid data" do
    assert_no_difference("Sector.count") do
      post_with_token api_v1_sectors_url,
                      params: { sector: { name: "" } },
                      as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to create sector", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should update sector" do
    patch_with_token api_v1_sector_url(@sector),
                     params: { sector: { name: "Deep Tech" } },
                     as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Sector updated successfully", json_response["message"]
    assert_equal "Deep Tech", json_response["data"]["sector"]["name"]

    @sector.reload
    assert_equal "Deep Tech", @sector.name
  end

  test "should not update sector with invalid data" do
    patch_with_token api_v1_sector_url(@sector),
                     params: { sector: { name: "" } },
                     as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to update sector", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should return not found when updating missing sector" do
    patch_with_token api_v1_sector_url(-1), params: { sector: { name: "Missing" } }, as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Sector not found", json_response["message"]
    assert_includes json_response["errors"], "Sector does not exist"
  end

  test "should delete sector" do
    sector = Sector.create!(name: "Temp")

    assert_difference("Sector.count", -1) do
      delete_with_token api_v1_sector_url(sector), as: :json
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Sector deleted successfully", json_response["message"]
  end

  test "should return not found when deleting missing sector" do
    delete_with_token api_v1_sector_url(-1), as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Sector not found", json_response["message"]
    assert_includes json_response["errors"], "Sector does not exist"
  end

  test "should handle missing payload" do
    post_with_token api_v1_sectors_url, params: {}, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "Sector parameters are required"
  end
end

