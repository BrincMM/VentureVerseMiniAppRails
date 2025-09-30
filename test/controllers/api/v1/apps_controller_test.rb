require "test_helper"

class Api::V1::AppsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @app_one = apps(:app_one)
    @app_two = apps(:app_two)
    
    # Add tags to test apps
    @app_one.tag_list.add("ai", "machine-learning")
    @app_one.save!
    @app_two.tag_list.add("blockchain", "finance")
    @app_two.save!
  end

  test "should reject request without token" do
    get api_v1_apps_url, as: :json
    assert_response :unauthorized
  end

  test "should reject request with invalid token" do
    get api_v1_apps_url, 
        headers: { 'Authorization' => 'Bearer invalid_token' },
        as: :json
    assert_response :unauthorized
  end

  test "should get list of apps" do
    get_with_token api_v1_apps_url, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Apps retrieved successfully", json_response["message"]
    assert_equal 2, json_response["data"]["total_count"]
    assert_equal 2, json_response["data"]["apps"].length
    assert_equal false, json_response["data"]["has_next"]
    assert_equal 1, json_response["data"]["total_pages"]
    assert_equal 10, json_response["data"]["per_page"]

    # Check tags
    app_one_response = json_response["data"]["apps"].find { |app| app["id"] == @app_one.id }
    assert_equal ["ai", "machine-learning"].sort, app_one_response["tags"].sort
    
    app_two_response = json_response["data"]["apps"].find { |app| app["id"] == @app_two.id }
    assert_equal ["blockchain", "finance"].sort, app_two_response["tags"].sort
  end

  test "should filter apps by category" do
    category = categories(:category_one)
    get_with_token api_v1_apps_url, params: { category_id: category.id }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["apps"].length
    app_payload = json_response["data"]["apps"].first
    assert_equal category.id, app_payload["category"]["id"]
    assert_equal category.name, app_payload["category"]["name"]
  end

  test "should filter apps by sector" do
    sector = sectors(:sector_two)
    get_with_token api_v1_apps_url, params: { sector_id: sector.id }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["apps"].length
    app_payload = json_response["data"]["apps"].first
    assert_equal sector.id, app_payload["sector"]["id"]
    assert_equal sector.name, app_payload["sector"]["name"]
  end

  test "should paginate apps" do
    # Create more apps for pagination testing
    category = Category.create!(name: "Pagination Category")
    sector = Sector.create!(name: "Pagination Sector")

    5.times do |i|
      App.create!(
        name: "Paginated App #{i}",
        category: category,
        sector: sector,
        link: "https://example.com/#{i}"
      )
    end

    get_with_token api_v1_apps_url, params: { per_page: 3, page: 1 }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 3, json_response["data"]["apps"].length
    assert_equal 7, json_response["data"]["total_count"]  # 2 fixture apps + 5 new apps
    assert_equal true, json_response["data"]["has_next"]
    assert_equal 3, json_response["data"]["total_pages"]
    assert_equal 3, json_response["data"]["per_page"]

    # Get next page
    get_with_token api_v1_apps_url, params: { per_page: 3, page: 2 }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal 3, json_response["data"]["apps"].length
    assert_equal true, json_response["data"]["has_next"]
  end

  test "should filter apps by tags" do
    get_with_token api_v1_apps_url, params: { tags: "ai,machine-learning" }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["apps"].length
    assert_equal @app_one.id, json_response["data"]["apps"][0]["id"]
    assert_equal ["ai", "machine-learning"].sort, json_response["data"]["apps"][0]["tags"].sort

    # Test single tag
    get_with_token api_v1_apps_url, params: { tags: "finance" }, as: :json
    assert_response :success
    
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["apps"].length
    assert_equal @app_two.id, json_response["data"]["apps"][0]["id"]
    assert_equal ["blockchain", "finance"].sort, json_response["data"]["apps"][0]["tags"].sort
  end

  test "should handle invalid per_page parameter" do
    get_with_token api_v1_apps_url, params: { per_page: 101 }, as: :json
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "Per page must be between 1 and 100"
  end
end