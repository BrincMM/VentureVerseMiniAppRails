# Create App Activity

Creates a new app activity record.

**URL**: `/api/v1/app_activities`

**Method**: `POST`

**Authentication required**: Yes

## Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| app_activity[user_id] | number | Yes | The ID of the user who performed the activity |
| app_activity[app_id] | number | Yes | The ID of the app the activity is related to |
| app_activity[activity_type] | string | Yes | The type of activity. Must be one of: `app_usage`, `content_procurement`, `perks_procurement`, `nft_procurement` |
| app_activity[app_meta] | json | No | Additional metadata about the activity |

## Request Example

```http
POST /api/v1/app_activities HTTP/1.1
Authorization: Bearer <API_TOKEN>
Content-Type: application/json

{
  "app_activity": {
    "user_id": 1,
    "app_id": 1,
    "activity_type": "app_usage",
    "app_meta": {
      "duration": "10m"
    }
  }
}
```

## Success Response

**Code**: `200 OK`

```json
{
  "success": true,
  "message": "Activity created successfully",
  "data": {
    "app_activity": {
      "id": 1,
      "activity_type": "app_usage",
      "app_id": 1,
      "user_id": 1,
      "app_meta": "{\"duration\":\"10m\"}",
      "timestamp": "2024-01-01T12:00:00Z",
      "created_at": "2024-01-01T12:00:00Z",
      "updated_at": "2024-01-01T12:00:00Z"
    }
  }
}
```

## Error Response

**Condition**: If validation fails or parameters are invalid.

**Code**: `422 UNPROCESSABLE ENTITY`

```json
{
  "success": false,
  "message": "Failed to create activity",
  "errors": [
    "User must exist",
    "App must exist",
    "Activity type can't be blank"
  ]
}
```