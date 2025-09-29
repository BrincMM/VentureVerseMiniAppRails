require "test_helper"

class Api::V1::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:category_one)
  end

  test "should reject request without token" do
    get api_v1_categories_url, as: :json
    assert_response :unauthorized
  end

  test "should list categories" do
    get_with_token api_v1_categories_url, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Categories retrieved successfully", json_response["message"]
    assert_equal 2, json_response["data"]["categories"].length
  end

  test "should filter categories by search" do
    get_with_token api_v1_categories_url, params: { search: "tech" }, as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal 1, json_response["data"]["categories"].length
    assert_equal "Technology", json_response["data"]["categories"].first["name"]
  end

  test "should handle invalid per_page" do
    get_with_token api_v1_categories_url, params: { per_page: 0 }, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "Per page must be between 1 and 100"
  end

  test "should create category" do
    assert_difference("Category.count", 1) do
      post_with_token api_v1_categories_url,
                      params: { category: { name: "Marketing" } },
                      as: :json
    end

    assert_response :created
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Category created successfully", json_response["message"]
    assert_equal "Marketing", json_response["data"]["category"]["name"]
  end

  test "should not create category with invalid data" do
    assert_no_difference("Category.count") do
      post_with_token api_v1_categories_url,
                      params: { category: { name: "" } },
                      as: :json
    end

    assert_response :unprocessable_entity
    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to create category", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should update category" do
    patch_with_token api_v1_category_url(@category),
                     params: { category: { name: "Fintech" } },
                     as: :json
    assert_response :success

    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Category updated successfully", json_response["message"]
    assert_equal "Fintech", json_response["data"]["category"]["name"]

    @category.reload
    assert_equal "Fintech", @category.name
  end

  test "should not update category with invalid data" do
    patch_with_token api_v1_category_url(@category),
                     params: { category: { name: "" } },
                     as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Failed to update category", json_response["message"]
    assert_includes json_response["errors"], "Name can't be blank"
  end

  test "should return not found when updating missing category" do
    patch_with_token api_v1_category_url(-1), params: { category: { name: "Missing" } }, as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Category not found", json_response["message"]
    assert_includes json_response["errors"], "Category does not exist"
  end

  test "should delete category" do
    category = Category.create!(name: "Temp")

    assert_difference("Category.count", -1) do
      delete_with_token api_v1_category_url(category), as: :json
    end

    assert_response :success
    json_response = JSON.parse(response.body)
    assert_equal true, json_response["success"]
    assert_equal "Category deleted successfully", json_response["message"]
  end

  test "should return not found when deleting missing category" do
    delete_with_token api_v1_category_url(-1), as: :json
    assert_response :not_found

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Category not found", json_response["message"]
    assert_includes json_response["errors"], "Category does not exist"
  end

  test "should handle missing payload" do
    post_with_token api_v1_categories_url, params: {}, as: :json
    assert_response :unprocessable_entity

    json_response = JSON.parse(response.body)
    assert_equal false, json_response["success"]
    assert_equal "Invalid parameters", json_response["message"]
    assert_includes json_response["errors"], "Category parameters are required"
  end
end

