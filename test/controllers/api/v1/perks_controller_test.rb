require "test_helper"

class Api::V1::PerksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @perk_one = perks(:perk_one)
    @perk_two = perks(:perk_two)

    @perk_one.tag_list.add("remote", "discount")
    @perk_one.save!
    @perk_two.tag_list.add("wellness", "health")
    @perk_two.save!
  end

  test "should reject request without token" do
    get api_v1_perks_url, as: :json
    assert_response :unauthorized
  end

  test "should reject request with invalid token" do
    get api_v1_perks_url,
        headers: { 'Authorization' => 'Bearer invalid_token' },
        as: :json
    assert_response :unauthorized
  end

  test "should list perks" do
    get_with_token api_v1_perks_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perks retrieved successfully", json_response["message"]
    assert_equal 2, json_response["data"]["total_count"]
    assert_equal 2, json_response["data"]["perks"].length
    assert_equal false, json_response["data"]["has_next"]
    assert_equal 1, json_response["data"]["total_pages"]
    assert_equal 10, json_response["data"]["per_page"]
    assert_equal 1, json_response["data"]["current_page"]

    perk_one_response = json_response["data"]["perks"].find { |perk| perk["id"] == @perk_one.id }
    assert_equal ["discount", "remote"].sort, perk_one_response["tags"].sort

    perk_two_response = json_response["data"]["perks"].find { |perk| perk["id"] == @perk_two.id }
    assert_equal ["health", "wellness"].sort, perk_two_response["tags"].sort
  end

  test "should filter perks by category" do
    category = categories(:category_one)
    get_with_token api_v1_perks_url, params: { category_id: category.id }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    perk_payload = json_response["data"]["perks"].first
    assert_equal category.id, perk_payload["category"]["id"]
    assert_equal category.name, perk_payload["category"]["name"]
  end

  test "should filter perks by sector" do
    sector = sectors(:sector_two)
    get_with_token api_v1_perks_url, params: { sector_id: sector.id }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    perk_payload = json_response["data"]["perks"].first
    assert_equal sector.id, perk_payload["sector"]["id"]
    assert_equal sector.name, perk_payload["sector"]["name"]
  end

  test "should filter perks by tags" do
    get_with_token api_v1_perks_url, params: { tags: "remote,discount" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    assert_equal @perk_one.id, json_response["data"]["perks"].first["id"]

    get_with_token api_v1_perks_url, params: { tags: "wellness" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["perks"].length
    assert_equal @perk_two.id, json_response["data"]["perks"].first["id"]
  end

  test "should paginate perks" do
    5.times do |i|
      category = Category.create!(name: "Category #{i}")
      sector = Sector.create!(name: "Sector #{i}")
      Perk.create!(
        partner_name: "Paginated Perk #{i}",
        category: category,
        sector: sector,
        company_website: "https://paginated#{i}.example.com",
        contact_email: "contact#{i}@example.com",
        contact: "Contact #{i}"
      )
    end

    get_with_token api_v1_perks_url, params: { per_page: 3, page: 1 }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 3, json_response["data"]["perks"].length
    assert_equal 7, json_response["data"]["total_count"]
    assert_equal true, json_response["data"]["has_next"]
    assert_equal 3, json_response["data"]["total_pages"]
    assert_equal 3, json_response["data"]["per_page"]
    assert_equal 1, json_response["data"]["current_page"]

    get_with_token api_v1_perks_url, params: { per_page: 3, page: 2 }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal 3, json_response["data"]["perks"].length
  end

  test "should handle invalid per_page parameter" do
    get_with_token api_v1_perks_url, params: { per_page: 0 }, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "Per page must be between 1 and 100"
  end

  test "should create perk" do
    category = Category.create!(name: "Technology Partners")
    sector = Sector.create!(name: "AI Services")

    assert_difference("Perk.count", 1) do
      post_with_token api_v1_perks_url,
                      params: {
                        perk: {
                          partner_name: "Gamma Partner",
                          category_id: category.id,
                          sector_id: sector.id,
                          company_website: "https://gamma.example.com",
                          contact_email: "contact@gamma.example.com",
                          contact: "Grace",
                          tags: "innovation,ai"
                        }
                      },
                      as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perk created successfully", json_response["message"]
    assert_equal ["ai", "innovation"].sort, json_response["data"]["perk"]["tags"].sort
    assert_equal category.id, json_response["data"]["perk"]["category"]["id"]
    assert_equal sector.id, json_response["data"]["perk"]["sector"]["id"]
  end

  test "should not create perk with invalid data" do
    category = categories(:category_one)
    sector = sectors(:sector_one)

    assert_no_difference("Perk.count") do
      post_with_token api_v1_perks_url,
                      params: {
                        perk: {
                          partner_name: "",
                          category_id: category.id,
                          sector_id: sector.id,
                          company_website: "https://invalid.example.com",
                          contact_email: "invalid@example.com",
                          contact: "Invalid"
                        }
                      },
                      as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "Partner name can't be blank"
  end

  test "should update perk" do
    new_category = Category.create!(name: "Updated Category")
    patch_with_token api_v1_perk_url(@perk_one),
                     params: {
                       perk: {
                         partner_name: "Updated Partner",
                         category_id: new_category.id,
                         tags: "remote,global"
                       }
                     },
                     as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perk updated successfully", json_response["message"]
    assert_equal ["global", "remote"].sort, json_response["data"]["perk"]["tags"].sort

    @perk_one.reload
    assert_equal "Updated Partner", @perk_one.partner_name
    assert_equal new_category.id, @perk_one.category_id
    assert_equal new_category.name, @perk_one.category.name
    assert_equal ["global", "remote"].sort, @perk_one.tag_list.sort
  end

  test "should not update perk with invalid data" do
    patch_with_token api_v1_perk_url(@perk_one),
                     params: {
                       perk: {
                         company_website: "",
                         contact_email: ""
                       }
                     },
                     as: :json

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_includes json_response["errors"], "Company website can't be blank"
    assert_includes json_response["errors"], "Contact email can't be blank"
  end

  test "should return not found when updating missing perk" do
    patch_with_token api_v1_perk_url(-1), params: { perk: { partner_name: "Missing" } }, as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Perk not found", json_response["message"]
    assert_includes json_response["errors"], "Perk does not exist"
  end

  test "should delete perk" do
    category = Category.create!(name: "Temp Category")
    sector = Sector.create!(name: "Temp Sector")
    perk = Perk.create!(
      partner_name: "Temp Partner",
      category: category,
      sector: sector,
      company_website: "https://temp.example.com",
      contact_email: "temp@example.com",
      contact: "Temp"
    )

    assert_difference("Perk.count", -1) do
      delete_with_token api_v1_perk_url(perk), as: :json
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Perk deleted successfully", json_response["message"]
  end

  test "should return not found when deleting missing perk" do
    delete_with_token api_v1_perk_url(-1), as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Perk not found", json_response["message"]
    assert_includes json_response["errors"], "Perk does not exist"
  end

  test "should handle missing perk payload" do
    post_with_token api_v1_perks_url, params: {}, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "Perk parameters are required"
  end
end

