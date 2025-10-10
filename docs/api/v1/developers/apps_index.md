# Developer Apps List API

This API endpoint retrieves all apps for a developer.

## Endpoints

### Option 1: Get apps by email parameter

```
GET /api/v1/developers/apps?email={developer_email}
```

### Option 2: Get apps by developer_id

```
GET /api/v1/developers/:developer_id/apps
```

## Authentication

Requires API Key in the Authorization header:
```
Authorization: Bearer YOUR_API_KEY
```

## Request Parameters

### For Option 1 (Query Parameter)

| Parameter | Type   | Required | Description |
|-----------|--------|----------|-------------|
| email     | string | Yes      | Developer's email address |
| status    | string | No       | Filter by app status: "active", "disabled", "reviewing", "dev" |

### For Option 2 (URL Parameter)

| Parameter    | Type    | Required | Description |
|--------------|---------|----------|-------------|
| developer_id | integer | Yes      | Developer's ID |
| status       | string  | No       | Filter by app status: "active", "disabled", "reviewing", "dev" |

## Request Examples

### Option 1 - Get all apps
```
GET /api/v1/developers/apps?email=developer@example.com
```

### Option 1 - Filter by status
```
GET /api/v1/developers/apps?email=developer@example.com&status=active
GET /api/v1/developers/apps?email=developer@example.com&status=dev
GET /api/v1/developers/apps?email=developer@example.com&status=reviewing
GET /api/v1/developers/apps?email=developer@example.com&status=disabled
```

### Option 2 - Get all apps
```
GET /api/v1/developers/123/apps
```

### Option 2 - Filter by status
```
GET /api/v1/developers/123/apps?status=active
GET /api/v1/developers/123/apps?status=dev
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
        "rate_limit_max_requests": null,
        "rate_limit_window_ms": null,
        "tags": ["tag1", "tag2"],
        "created_at": "2025-01-15T10:30:00.000Z",
        "updated_at": "2025-01-15T10:30:00.000Z",
        "api_keys": [
          {
            "id": 1,
            "api_key": "abc123def456...",
            "rate_limit_per_minute": 100,
            "rate_limit_per_day": 10000,
            "status": "active",
            "expires_at": null,
            "last_used_at": "2025-01-20T14:30:00.000Z",
            "created_at": "2025-01-15T10:30:00.000Z"
          }
        ]
      }
    ],
    "total_count": 1
  }
}
```

## Error Responses

### Status Code: 400 Bad Request (Option 1 only)

When email parameter is missing:

```json
{
  "success": false,
  "message": "Email parameter is required",
  "errors": null
}
```

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
| status                   | string   | App status: "active", "disabled", "reviewing", "dev" |
| developer_id             | integer  | Developer ID |
| rate_limit_max_requests  | integer  | Max requests (legacy field) |
| rate_limit_window_ms     | integer  | Rate limit window (legacy field) |
| tags                     | array    | Array of tag strings |
| created_at               | string   | ISO 8601 timestamp |
| updated_at               | string   | ISO 8601 timestamp |
| api_keys                 | array    | Array of active API key objects |

### API Key Object

| Field                  | Type     | Description |
|------------------------|----------|-------------|
| id                     | integer  | API key ID |
| api_key                | string   | The actual API key |
| rate_limit_per_minute  | integer  | Rate limit per minute |
| rate_limit_per_day     | integer  | Rate limit per day |
| status                 | string   | Status: "active", "revoked", "expired" |
| expires_at             | string   | Expiration timestamp (nullable) |
| last_used_at           | string   | Last usage timestamp (nullable) |
| created_at             | string   | ISO 8601 timestamp |

## Status Filter

The `status` parameter allows filtering apps by their current status:

- **`active`**: Apps that are live and publicly available
- **`disabled`**: Apps that have been disabled/soft-deleted
- **`reviewing`**: Apps under review before going live
- **`dev`**: Apps in development mode (not yet published)

When no `status` parameter is provided, all apps regardless of status are returned.

If an invalid status value is provided, all apps are returned (filter is ignored).

## Notes

- Only active API keys are included in the response
- Apps are returned with all their associated data (category, sector, tags)
- No pagination is currently implemented
- Both endpoints return the same response format
- Status filtering is case-insensitive and strips whitespace
- Developer can see all their apps regardless of status (unlike the public API which only shows active/reviewing apps)

