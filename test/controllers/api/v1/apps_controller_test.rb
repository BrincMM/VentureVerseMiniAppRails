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

  test "should reject filters request without token" do
    get filters_api_v1_apps_path, as: :json
    assert_response :unauthorized
  end

  test "should reject filters request with invalid token" do
    get filters_api_v1_apps_path,
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
        app_url: "https://example.com/#{i}",
        status: :active
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

  test "should return app filters" do
    get_with_token filters_api_v1_apps_path, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "App filters retrieved successfully", json_response["message"]

    categories = json_response.dig("data", "used_categories")
    sectors = json_response.dig("data", "used_sectors")
    tags = json_response.dig("data", "used_tags")

    assert_equal 2, categories.length
    assert_equal 2, sectors.length
    assert_equal 4, tags.length

    technology_category = categories.find { |category| category["name"] == categories(:category_one).name }
    assert_equal 1, technology_category["count"]

    ai_sector = sectors.find { |sector| sector["name"] == sectors(:sector_one).name }
    assert_equal 1, ai_sector["count"]

    ai_tag = tags.find { |tag| tag["name"] == "ai" }
    assert_equal 1, ai_tag["count"]
  end

  test "should filter app filters by tags" do
    get_with_token filters_api_v1_apps_path, params: { tags: "ai" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    categories = json_response.dig("data", "used_categories")
    sectors = json_response.dig("data", "used_sectors")
    tags = json_response.dig("data", "used_tags")

    assert_equal 1, categories.length
    assert_equal 1, sectors.length
    assert_equal 1, tags.length

    assert_equal categories(:category_one).id, categories.first["id"]
    assert_equal sectors(:sector_one).id, sectors.first["id"]
    assert_equal "ai", tags.first["name"]
  end

  test "should handle invalid per_page parameter" do
    get_with_token api_v1_apps_url, params: { per_page: 101 }, as: :json
    assert_response :unprocessable_entity
    
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "Per page must be between 1 and 100"
  end

  test "should create app" do
    category = categories(:category_one)
    sector = sectors(:sector_one)

    assert_difference("App.count", 1) do
      post_with_token api_v1_apps_url,
                      params: {
                        app: {
                          name: "New Test App",
                          description: "A brand new app",
                          app_url: "https://new-app.example.com",
                          category_id: category.id,
                          sector_id: sector.id,
                          sort_order: 15,
                          tags: ["productivity", "automation"]
                        }
                      },
                      as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "App created successfully", json_response["message"]
    app_payload = json_response["data"]["app"]
    assert_equal "New Test App", app_payload["app_name"]
    assert_equal ["productivity", "automation"].sort, app_payload["tags"].sort

    created_app = App.find(app_payload["id"])
    assert_equal ["productivity", "automation"].sort, created_app.tag_list.sort
    assert_equal 15, created_app.sort_order
  end

  test "should not create app with invalid data" do
    assert_no_difference("App.count") do
      post_with_token api_v1_apps_url,
                      params: {
                        app: {
                          name: "",
                          app_url: "invalid-url"
                        }
                      },
                      as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to create app", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should update app" do
    patch_with_token api_v1_app_url(@app_one),
                     params: {
                       app: {
                         name: "Updated App Name",
                         description: "Updated description",
                         tags: ["updated", "ai"]
                       }
                     },
                     as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "App updated successfully", json_response["message"]
    app_payload = json_response["data"]["app"]
    assert_equal "Updated App Name", app_payload["app_name"]
    assert_equal ["updated", "ai"].sort, app_payload["tags"].sort

    @app_one.reload
    assert_equal "Updated App Name", @app_one.name
    assert_equal ["updated", "ai"].sort, @app_one.tag_list.sort
    assert_equal "Updated description", @app_one.description
  end

  test "should clear tags when provided empty array" do
    patch_with_token api_v1_app_url(@app_one),
                     params: {
                       app: {
                         tags: []
                       }
                     },
                     as: :json

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal [], json_response["data"]["app"]["tags"]

    @app_one.reload
    assert_equal [], @app_one.tag_list
  end

  test "should not update app with invalid data" do
    patch_with_token api_v1_app_url(@app_one),
                     params: {
                       app: {
                         name: ""
                       }
                     },
                     as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to update app", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should return not found when updating missing app" do
    patch_with_token api_v1_app_url(-1),
                     params: {
                       app: {
                         name: "Missing App"
                       }
                     },
                     as: :json

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "App not found", json_response["message"]
    assert_includes json_response["errors"], "App does not exist"
  end

  test "should delete app" do
    category = categories(:category_two)
    sector = sectors(:sector_two)
    app = App.create!(
      name: "Disposable App",
      description: "Temporary app",
      app_url: "https://disposable.example.com",
      category: category,
      sector: sector
    )

    assert_difference("App.count", -1) do
      delete_with_token api_v1_app_url(app), as: :json
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "App deleted successfully", json_response["message"]
  end

  test "should return not found when deleting missing app" do
    delete_with_token api_v1_app_url(-1), as: :json

    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "App not found", json_response["message"]
    assert_includes json_response["errors"], "App does not exist"
  end

  test "should handle missing payload on create" do
    post_with_token api_v1_apps_url, params: {}, as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "App parameters are required"
  end
end