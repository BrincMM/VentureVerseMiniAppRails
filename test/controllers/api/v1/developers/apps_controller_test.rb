require "test_helper"

module Api
  module V1
    module Developers
      class AppsControllerTest < ActionDispatch::IntegrationTest
        setup do
          @developer = developers(:one)
          @developer_two = developers(:two)
          @app_one = apps(:app_one)
          @app_two = apps(:app_two)
          @app_three = apps(:app_three)
          @category = categories(:category_one)
          @sector = sectors(:sector_one)
        end

        # INDEX tests (RESTful nested route)
        test "should reject index request without token" do
          get api_v1_developer_apps_url(@developer), as: :json
          assert_response :unauthorized
        end
        test "should get apps by developer_id using nested route" do
          get_with_token api_v1_developer_apps_url(@developer), as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "Apps retrieved successfully", json_response["message"]
          
          apps_data = json_response["data"]["apps"]
          assert_equal 2, apps_data.size
        end

        test "should fail with non-existent developer_id using nested route" do
          get_with_token api_v1_developer_apps_url(developer_id: 99999), as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        # STATUS FILTER tests
        test "should filter apps by status active" do
          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'active' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 2, apps_data.size
          apps_data.each do |app|
            assert_equal "active", app["status"]
          end
        end

        test "should filter apps by status dev" do
          # Create a dev app for developer one
          dev_app = App.create!(
            name: "Dev App",
            description: "Development app",
            category: @category,
            sector: @sector,
            developer: @developer,
            status: :dev
          )

          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'dev' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 1, apps_data.size
          assert_equal dev_app.id, apps_data.first["id"]
          assert_equal "dev", apps_data.first["status"]
        end

        test "should filter apps by status reviewing" do
          # Create a reviewing app for developer one
          reviewing_app = App.create!(
            name: "Reviewing App",
            description: "Under review app",
            category: @category,
            sector: @sector,
            developer: @developer,
            status: :reviewing
          )

          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'reviewing' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 1, apps_data.size
          assert_equal reviewing_app.id, apps_data.first["id"]
          assert_equal "reviewing", apps_data.first["status"]
        end

        test "should filter apps by status disabled" do
          # Create a disabled app for developer one
          disabled_app = App.create!(
            name: "Disabled App",
            description: "Disabled app",
            category: @category,
            sector: @sector,
            developer: @developer,
            status: :disabled
          )

          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'disabled' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 1, apps_data.size
          assert_equal disabled_app.id, apps_data.first["id"]
          assert_equal "disabled", apps_data.first["status"]
        end

        test "should return all apps when status parameter is not provided" do
          # Create apps with different statuses
          App.create!(name: "Dev App for Filter", category: @category, sector: @sector, developer: @developer, status: :dev)
          App.create!(name: "Reviewing App for Filter", category: @category, sector: @sector, developer: @developer, status: :reviewing)

          get_with_token api_v1_developer_apps_url(@developer), as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 4, apps_data.size  # 2 active + 1 dev + 1 reviewing
        end

        test "should return all apps when status parameter is invalid" do
          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'invalid_status' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 2, apps_data.size  # All apps returned when invalid status
        end

        test "should filter apps by status using developer_id endpoint" do
          # Test status filter works with the developer_id endpoint too
          dev_app = App.create!(
            name: "Dev App via ID",
            category: @category,
            sector: @sector,
            developer: @developer,
            status: :dev
          )

          get_with_token api_v1_developer_apps_url(@developer), params: { status: 'dev' }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          apps_data = json_response["data"]["apps"]
          assert_equal 1, apps_data.size
          assert_equal "dev", apps_data.first["status"]
        end

        # SHOW tests
        test "should show app" do
          get_with_token api_v1_developers_app_url(@app_one), as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "App retrieved successfully", json_response["message"]
          
          app_data = json_response["data"]["app"]
          assert_equal @app_one.id, app_data["id"]
          assert_equal @app_one.name, app_data["name"]
          assert_equal @app_one.description, app_data["description"]
        end

        test "should fail show with non-existent app" do
          get_with_token api_v1_developers_app_url(id: 99999), as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "App not found", json_response["message"]
        end

        # CREATE tests
        test "should create app" do
          assert_difference('App.count', 1) do
            post_with_token api_v1_developers_apps_url, params: {
              developer_id: @developer.id,
              name: "New Test App",
              description: "A new test application",
              app_url: "https://newapp.example.com",
              category_id: @category.id,
              sector_id: @sector.id
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "App created successfully", json_response["message"]
          
          app_data = json_response["data"]["app"]
          assert_equal "New Test App", app_data["name"]
          assert_equal "A new test application", app_data["description"]
          assert_equal "dev", app_data["status"]
          assert_equal @developer.id, app_data["developer_id"]
        end

        test "should fail create with non-existent developer" do
          post_with_token api_v1_developers_apps_url, params: {
            developer_id: 99999,
            name: "New Test App",
            description: "A new test application"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "Developer not found", json_response["message"]
        end

        test "should fail create with duplicate name" do
          post_with_token api_v1_developers_apps_url, params: {
            developer_id: @developer.id,
            name: @app_one.name,  # Duplicate name
            description: "A test application"
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_includes json_response["errors"], "Name has already been taken"
        end

        test "should fail create with missing name" do
          post_with_token api_v1_developers_apps_url, params: {
            developer_id: @developer.id,
            description: "A test application"
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_includes json_response["errors"], "Name can't be blank"
        end

        test "should create app with tags as array" do
          assert_difference('App.count', 1) do
            post_with_token api_v1_developers_apps_url, params: {
              developer_id: @developer.id,
              name: "Tagged App",
              description: "App with tags",
              category_id: @category.id,
              sector_id: @sector.id,
              tags: ["productivity", "automation", "api"]
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          
          app_data = json_response["data"]["app"]
          assert_equal "Tagged App", app_data["name"]
          assert_equal ["api", "automation", "productivity"], app_data["tags"].sort
        end

        test "should create app with tags as comma-separated string" do
          assert_difference('App.count', 1) do
            post_with_token api_v1_developers_apps_url, params: {
              developer_id: @developer.id,
              name: "String Tagged App",
              description: "App with string tags",
              category_id: @category.id,
              sector_id: @sector.id,
              tags: "workflow, integration, saas"
            }, as: :json
          end

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          
          app_data = json_response["data"]["app"]
          assert_equal "String Tagged App", app_data["name"]
          assert_equal ["integration", "saas", "workflow"], app_data["tags"].sort
        end

        # UPDATE tests
        test "should update app" do
          patch_with_token api_v1_developers_app_url(@app_one), params: {
            name: "Updated App Name",
            description: "Updated description"
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "App updated successfully", json_response["message"]
          
          app_data = json_response["data"]["app"]
          assert_equal "Updated App Name", app_data["name"]
          assert_equal "Updated description", app_data["description"]
        end

        test "should fail update with non-existent app" do
          patch_with_token api_v1_developers_app_url(id: 99999), params: {
            name: "Updated App Name"
          }, as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "App not found", json_response["message"]
        end

        test "should fail update with duplicate name" do
          patch_with_token api_v1_developers_app_url(@app_one), params: {
            name: @app_two.name  # Duplicate name
          }, as: :json

          assert_response :unprocessable_entity
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_includes json_response["errors"], "Name has already been taken"
        end

        test "should update app status" do
          patch_with_token api_v1_developers_app_url(@app_one), params: {
            status: "active"
          }, as: :json

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          
          app_data = json_response["data"]["app"]
          assert_equal "active", app_data["status"]
        end

        # DESTROY tests
        test "should soft delete app" do
          assert_no_difference('App.count') do
            delete_with_token api_v1_developers_app_url(@app_one), as: :json
          end

          assert_response :ok
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "App disabled successfully", json_response["message"]
          
          app_data = json_response["data"]["app"]
          assert_equal "disabled", app_data["status"]
          
          # Verify app still exists but is disabled
          @app_one.reload
          assert_equal "disabled", @app_one.status
        end

        test "should fail destroy with non-existent app" do
          delete_with_token api_v1_developers_app_url(id: 99999), as: :json

          assert_response :not_found
          json_response = JSON.parse(response.body)
          
          assert_equal false, json_response["success"]
          assert_equal "App not found", json_response["message"]
        end

        # NAME UNIQUENESS tests (with disabled status)
        test "should allow creating app with same name as disabled app" do
          # First, disable an existing app
          delete_with_token api_v1_developers_app_url(@app_one), as: :json
          assert_response :ok
          
          # Now create a new app with the same name
          post_with_token api_v1_developers_apps_url, params: {
            developer_id: @developer.id,
            name: @app_one.name,  # Same name as disabled app
            description: "New app with previously used name",
            category_id: @category.id,
            sector_id: @sector.id
          }, as: :json

          assert_response :created
          json_response = JSON.parse(response.body)
          
          assert_equal true, json_response["success"]
          assert_equal "App created successfully", json_response["message"]
          
          app_data = json_response["data"]["app"]
          assert_equal @app_one.name, app_data["name"]
          assert_equal "dev", app_data["status"]
        end

        test "should allow multiple disabled apps with same name" do
          # Disable app_one
          delete_with_token api_v1_developers_app_url(@app_one), as: :json
          assert_response :ok
          
          # Create and disable app_two with same name
          patch_with_token api_v1_developers_app_url(@app_two), params: {
            name: @app_one.name
          }, as: :json
          assert_response :ok
          
          delete_with_token api_v1_developers_app_url(@app_two), as: :json
          assert_response :ok
          
          # Verify both apps have same name and are disabled
          @app_one.reload
          @app_two.reload
          assert_equal @app_one.name, @app_two.name
          assert_equal "disabled", @app_one.status
          assert_equal "disabled", @app_two.status
        end
      end
    end
  end
end

