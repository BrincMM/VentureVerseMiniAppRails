# Developer Update App API

This API endpoint updates an existing app.

## Endpoint

```
PATCH /api/v1/developers/apps/:id
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## URL Parameters

| Parameter | Type    | Required | Description |
|-----------|---------|----------|-------------|
| id        | integer | Yes      | App ID |

## Request Parameters

All parameters are optional. Only provide the fields you want to update.

| Parameter                        | Type    | Required | Description |
|----------------------------------|---------|----------|-------------|
| name                             | string  | No       | App name (must be globally unique) |
| description                      | string  | No       | App description |
| app_url                          | string  | No       | Webhook URL (must be valid URL format) |
| category_id                      | integer | No       | Category ID |
| sector_id                        | integer | No       | Sector ID |
| status                           | string  | No       | App status: "active", "disabled", "reviewing", "dev" |
| rate_limit_requests_per_day      | integer | No       | Maximum requests per day |
| rate_limit_requests_per_minute   | integer | No       | Maximum requests per minute |

## Request Example

```json
{
  "name": "Updated App Name",
  "description": "Updated description",
  "app_url": "https://newurl.example.com/webhook",
  "status": "active",
  "rate_limit_requests_per_day": 5000,
  "rate_limit_requests_per_minute": 100
}
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "App updated successfully",
  "data": {
    "app": {
      "id": 123,
      "name": "Updated App Name",
      "description": "Updated description",
      "category": {
        "id": 1,
        "name": "Social Media"
      },
      "sector": {
        "id": 1,
        "name": "Technology"
      },
      "app_url": "https://newurl.example.com/webhook",
      "status": "active",
      "developer_id": 456,
      "rate_limit_requests_per_day": 5000,
      "rate_limit_requests_per_minute": 100,
      "tags": ["tag1", "tag2"],
      "created_at": "2025-01-15T10:30:00.000Z",
      "updated_at": "2025-01-20T14:30:00.000Z"
    }
  }
}
```

## Error Responses

### Status Code: 404 Not Found

When app is not found:

```json
{
  "success": false,
  "message": "App not found",
  "errors": null
}
```

### Status Code: 422 Unprocessable Entity

When validation fails:

```json
{
  "success": false,
  "message": "Failed to update app",
  "errors": [
    "Name has already been taken",
    "App url is invalid"
  ]
}
```

## Validation Rules

1. **name**: 
   - If provided, must be globally unique (not per developer)
   - Cannot be blank if provided
2. **app_url**: 
   - If provided, must be a valid URL format
3. **status**: 
   - If provided, must be one of: "active", "disabled", "reviewing", "dev"
4. **category_id**: If provided, must reference an existing category
5. **sector_id**: If provided, must reference an existing sector

## Notes

- No ownership verification is performed (any valid API key can update any app)
- Only the provided fields are updated; other fields remain unchanged
- Use the `status` field to activate, disable, or mark apps for review
- The `updated_at` timestamp is automatically updated

## Status Values

| Status    | Description |
|-----------|-------------|
| dev       | Development mode (default for new apps) |
| active    | Active and available |
| reviewing | Under review |
| disabled  | Disabled (soft deleted) |

## Related Endpoints

- To disable an app, you can also use `DELETE /api/v1/developers/apps/:id` (sets status to "disabled")
- To view app details, use `GET /api/v1/developers/apps/:id`

