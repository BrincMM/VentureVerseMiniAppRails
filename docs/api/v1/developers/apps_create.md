# Developer Create App API

This API endpoint creates a new app for a developer.

## Endpoint

```
POST /api/v1/developers/apps
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter                        | Type    | Required | Description |
|----------------------------------|---------|----------|-------------|
| developer_id                     | integer | Yes      | Developer's ID |
| name                             | string  | Yes      | App name (must be globally unique) |
| description                      | string  | No       | App description |
| app_url                          | string  | No       | Webhook URL (must be valid URL format) |
| category_id                      | integer | No       | Category ID |
| sector_id                        | integer | No       | Sector ID |
| status                           | string  | No       | App status: "active", "disabled", "reviewing", "dev" (defaults to "dev") |
| rate_limit_requests_per_day      | integer | No       | Maximum number of requests allowed per day |
| rate_limit_requests_per_minute   | integer | No       | Maximum number of requests allowed per minute |
| tags                             | array   | No       | Array of tag strings or comma-separated string |

## Request Example

```json
{
  "developer_id": 456,
  "name": "My App",
  "description": "My application description",
  "app_url": "https://example.com/webhook",
  "category_id": 1,
  "sector_id": 1,
  "status": "dev",
  "rate_limit_requests_per_day": 10000,
  "rate_limit_requests_per_minute": 100,
  "tags": ["productivity", "automation"]
}
```

## Success Response

### Status Code: 201 Created

```json
{
  "success": true,
  "message": "App created successfully",
  "data": {
    "app": {
      "id": 123,
      "name": "My App",
      "description": "My application description",
      "category": {
        "id": 1,
        "name": "Social Media"
      },
      "sector": {
        "id": 1,
        "name": "Technology"
      },
      "app_url": "https://example.com/webhook",
      "status": "dev",
      "developer_id": 456,
      "rate_limit_requests_per_day": null,
      "rate_limit_requests_per_minute": null,
      "tags": [],
      "created_at": "2025-01-15T10:30:00.000Z",
      "updated_at": "2025-01-15T10:30:00.000Z"
    }
  }
}
```

## Error Responses

### Status Code: 404 Not Found

When developer is not found:

```json
{
  "success": false,
  "message": "Developer not found",
  "errors": null
}
```

### Status Code: 422 Unprocessable Entity

When validation fails:

```json
{
  "success": false,
  "message": "Failed to create app",
  "errors": [
    "Name can't be blank",
    "Name has already been taken"
  ]
}
```

## Validation Rules

1. **developer_id**: Must be provided and match an existing developer
2. **name**: 
   - Required
   - Must be globally unique (not per developer)
3. **app_url**: 
   - Optional
   - If provided, must be a valid URL format
4. **status**: 
   - Optional
   - Valid values: "active", "disabled", "reviewing", "dev"
   - Defaults to "dev" if not provided
5. **category_id**: Optional, must reference an existing category
6. **sector_id**: Optional, must reference an existing sector
7. **rate_limit_requests_per_day**: Optional, integer value for maximum requests allowed per day
8. **rate_limit_requests_per_minute**: Optional, integer value for maximum requests allowed per minute
9. **tags**: 
   - Optional
   - Can be provided as an array of strings or a comma-separated string
   - Empty tags will be ignored

## Notes

- Default status is "dev" for new apps
- API keys are NOT automatically created when an app is created
- App names must be globally unique across all developers
- The app is immediately available after creation
- No ownership verification is required during creation

## Related Endpoints

- To create an API key for this app, see [API Keys documentation](./api_keys_create.md)
- To update app details, use `PATCH /api/v1/developers/apps/:id`
- To list all apps, use `GET /api/v1/developers/:developer_id/apps`

