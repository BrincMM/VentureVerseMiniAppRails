# Update App

Updates an existing app and optionally replaces its tags.

**URL** : `/api/v1/apps/:id`

**Method** : `PATCH`

## Request Example

```http
PATCH /api/v1/apps/3 HTTP/1.1
Host: api.ventureverse.example
Authorization: Bearer <access_token>
Content-Type: application/json

{
  "app": {
    "name": "Productivity Tool Pro",
    "description": "Adds advanced automation features",
    "sort_order": 3,
    "tags": ["automation", "workflow"]
  }
}
```

## Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| app | object | Yes | Wrapper for the app payload |
| name | string | No | Updated app name (must remain unique) |
| description | string | No | Updated description |
| app_url | string | No | Updated app URL (must be a valid URL if provided) |
| category_id | number | No | Updated category association |
| sector_id | number | No | Updated sector association |
| sort_order | number | No | Updated sort order |
| status | string | No | Updated app status (active, disabled, reviewing, dev) |
| developer_id | number | No | Updated developer ID |
| rate_limit_requests_per_day | number | No | Updated maximum number of requests allowed per day |
| rate_limit_requests_per_minute | number | No | Updated maximum number of requests allowed per minute |
| tags | array<string> or string | No | Replaces the tag list; send an empty array to clear tags |

## Success Response

**Code** : `200 OK`

```json
{
  "success": true,
  "message": "App updated successfully",
  "data": {
    "app": {
      "id": 3,
      "app_name": "Productivity Tool Pro",
      "description": "Adds advanced automation features",
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
      "rate_limit_requests_per_day": 10000,
      "rate_limit_requests_per_minute": 100,
      "tags": ["automation", "workflow"],
      "created_at": "2025-01-01T00:00:00Z",
      "updated_at": "2025-01-02T12:00:00Z"
    }
  }
}
```

## Error Response

Errors follow the shared `general/errors.json` format.

**Condition** : Missing wrapper key, invalid payload, validation failure, or missing record.

**Code** : `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to update app",
  "errors": [
    "Name can't be blank"
  ]
}
```

**Code** : `404 NOT FOUND`

```json
{
  "success": false,
  "message": "App not found",
  "errors": [
    "App does not exist"
  ]
}
```

## Notes

- Provide only the fields you want to update; omitted attributes remain unchanged.
- Sending the `tags` key replaces the entire tag list, allowing tag removal with an empty array.
- All error responses reuse `api/v1/general/errors.json.jbuilder`.

