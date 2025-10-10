# Create App

Creates a new app record and optionally assigns tags.

**URL** : `/api/v1/apps`

**Method** : `POST`

## Request Example

```http
POST /api/v1/apps HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "app": {
    "name": "New Productivity Tool",
    "description": "Helps automate repetitive workflows",
    "app_url": "https://productivity.example.com",
    "category_id": 1,
    "sector_id": 2,
    "sort_order": 5,
    "status": "active",
    "developer_id": 123,
    "tags": ["automation", "productivity"]
  }
}
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| app | object | Yes | Wrapper for the app payload |
| name | string | Yes | App name (must be unique) |
| description | string | No | App description |
| app_url | string | No | App URL (must be a valid URL if provided) |
| category_id | number | No | Category association |
| sector_id | number | No | Sector association |
| sort_order | number | No | Sort order used when listing apps |
| status | string | No | App status (active, disabled, reviewing, dev) |
| developer_id | number | No | Developer ID |
| tags | array<string> or string | No | Tags to assign; send an array or a comma-separated string |

## Success Response

**Code** : `201 CREATED`

```json
{
  "success": true,
  "message": "App created successfully",
  "data": {
    "app": {
      "id": 3,
      "app_name": "New Productivity Tool",
      "description": "Helps automate repetitive workflows",
      "category": {
        "id": 1,
        "name": "AI"
      },
      "sector": {
        "id": 2,
        "name": "Technology"
      },
      "app_url": "https://productivity.example.com",
      "status": "active",
      "developer_id": 123,
      "tags": ["automation", "productivity"],
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-01T00:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : Missing wrapper key, invalid payload, or validation failure.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to create app",
  "errors": [
    "Name can't be blank"
  ]
}
```

## Notes

- Provide the wrapper key `app` in the request payload.
- Send tags as an array of strings or as a comma-separated string; empty arrays remove all tags.
- All error responses reuse `api/v1/general/errors.json.jbuilder`.

