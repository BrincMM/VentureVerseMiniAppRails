# Developer Apps List API

This API endpoint retrieves all apps for a developer.

## Endpoint

```
GET /api/v1/developers/:developer_id/apps
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

| Parameter    | Type    | Required | Description |
|--------------|---------|----------|-------------|
| developer_id | integer | Yes      | Developer's ID (in URL path) |
| status       | string  | No       | Filter by app status: "active", "disabled", "reviewing", "dev" |

## Request Examples

### Get all apps
```
GET /api/v1/developers/123/apps
```

### Filter by status
```
GET /api/v1/developers/123/apps?status=active
GET /api/v1/developers/123/apps?status=dev
GET /api/v1/developers/123/apps?status=reviewing
GET /api/v1/developers/123/apps?status=disabled
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "Apps retrieved successfully",
  "data": {
    "apps": [
      {
        "id": 1,
        "name": "My App",
        "description": "App description",
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
        "developer_id": 123,
        "rate_limit_requests_per_day": null,
        "rate_limit_requests_per_minute": null,
        "tags": ["tag1", "tag2"],
        "created_at": "2025-01-15T10:30:00.000Z",
        "updated_at": "2025-01-15T10:30:00.000Z"
      }
    ],
    "total_count": 1
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

## Response Fields

### App Object

| Field                    | Type     | Description |
|--------------------------|----------|-------------|
| id                       | integer  | App ID |
| name                     | string   | App name |
| description              | string   | App description |
| category                 | object   | Category information (id, name) |
| sector                   | object   | Sector information (id, name) |
| app_url                  | string   | Webhook URL |
| status                          | string   | App status: "active", "disabled", "reviewing", "dev" |
| developer_id                    | integer  | Developer ID |
| rate_limit_requests_per_day     | integer  | Maximum number of requests allowed per day |
| rate_limit_requests_per_minute  | integer  | Maximum number of requests allowed per minute |
| tags                            | array    | Array of tag strings |
| created_at                      | string   | ISO 8601 timestamp |
| updated_at                      | string   | ISO 8601 timestamp |

## Status Filter

The `status` parameter allows filtering apps by their current status:

- **`active`**: Apps that are live and publicly available
- **`disabled`**: Apps that have been disabled/soft-deleted
- **`reviewing`**: Apps under review before going live
- **`dev`**: Apps in development mode (not yet published)

When no `status` parameter is provided, all apps regardless of status are returned.

If an invalid status value is provided, all apps are returned (filter is ignored).

## Notes

- Apps are returned with all their associated data (category, sector, tags)
- API keys are not included in the list response (use the show endpoint or API keys endpoints to retrieve keys)
- No pagination is currently implemented
- Status filtering is case-insensitive and strips whitespace
- Developer can see all their apps regardless of status (unlike the public API which only shows active/reviewing apps)
- The `developer_id` must be provided in the URL path

