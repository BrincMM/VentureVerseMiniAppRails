# Create Login History

Creates a new login history record.

**URL**: `/api/v1/log_in_histories`

**Method**: `POST`

**Authentication required**: Yes

## Request Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| log_in_history[user_id] | number | Yes | The ID of the user who logged in |
| log_in_history[metadata] | json | Yes | Additional metadata about the login (e.g. browser info, IP address) |

## Request Example

```http
POST /api/v1/log_in_histories HTTP/1.1
Authorization: Bearer <token>
Content-Type: application/json

{
  "log_in_history": {
    "user_id": 1,
    "metadata": {
      "browser": "Chrome",
      "ip": "127.0.0.1"
    }
  }
}
```

## Success Response

**Code**: `200 OK`

```json
{
  "success": true,
  "message": "Login history created successfully",
  "data": {
    "log_in_history": {
      "id": 1,
      "user_id": 1,
      "timestamp": "2024-01-01T12:00:00Z",
      "metadata": "{\"browser\":\"Chrome\",\"ip\":\"127.0.0.1\"}",
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
  "message": "Failed to create login history",
  "errors": [
    "User must exist",
    "Metadata must be valid JSON"
  ]
}
```