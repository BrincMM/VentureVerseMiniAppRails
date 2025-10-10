# Developer App Details API

This API endpoint retrieves details of a specific app.

## Endpoint

```
GET /api/v1/developers/apps/:id
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

## Request Example

```
GET /api/v1/developers/apps/123
```

## Success Response

### Status Code: 200 OK

```json
{
  "success": true,
  "message": "App retrieved successfully",
  "data": {
    "app": {
      "id": 123,
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
      "status": "active",
      "developer_id": 456,
      "rate_limit_max_requests": null,
      "rate_limit_window_ms": null,
      "tags": ["tag1", "tag2"],
      "created_at": "2025-01-15T10:30:00.000Z",
      "updated_at": "2025-01-20T14:30:00.000Z",
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
  }
}
```

## Error Response

### Status Code: 404 Not Found

When app is not found:

```json
{
  "success": false,
  "message": "App not found",
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

## Notes

- Only active API keys are included in the response
- App is returned with all associated data (category, sector, tags)
- No permission check is performed (any valid API key can view any app)

